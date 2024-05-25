//
//  CustomImagePicker.swift
//  CropImageView
//
//  Created by 엄기철 on 5/26/24.
//

import SwiftUI
import PhotosUI

// MARK: View Extensions
extension View {
    @ViewBuilder
    func cropImagePicker(options: [Crop], show: Binding<Bool>, croppedImage: Binding<UIImage?>) -> some View {
        CustomImagePicker(options: options, show: show, croppedImage: croppedImage) {
            self
            
        }
    }
    
    /// For Making it Simple and easy to use
    @ViewBuilder
    func frame(_ size: CGSize) -> some View {
        self
            .frame(width: size.width, height: size.height)
    }
    
    /// Haptic Feedback
    func haptics(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

private struct CustomImagePicker<Content: View>: View {
    var content: Content
    var options: [Crop]
    @Binding var show: Bool
    @Binding var croppedImage: UIImage?
    init(options: [Crop], show: Binding<Bool>, croppedImage: Binding<UIImage?>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self._show = show
        self._croppedImage = croppedImage
        self.options = options
    }
    
    /// View Properties
    @State private var photosItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showDialog: Bool = false
    @State private var selectedCropType: Crop = .circle
    @State private var showCropView: Bool = false
    
    var body: some View {
        content
            .photosPicker(isPresented: $show, selection: $photosItem)
            .onChange(of: photosItem) { oldValue, newValue in
                /// Extracting UIImage From Photos Item
                if let newValue {
                    Task {
                        if let imageData = try? await newValue.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                            /// UI Must be updated on Main Thread
                            await MainActor.run {
                                selectedImage = image
                                showDialog.toggle()
                            }
                        }
                    }
                }
            }
            .confirmationDialog("", isPresented: $showDialog) {
                /// Displaying whatever options are given by the user in an action sheet format.
                ForEach(options.indices, id: \.self) { index in
                    Button(options[index].name()) {
                        selectedCropType = options[index]
                        showCropView.toggle()
                    }
                }
            }
            .fullScreenCover(isPresented: $showCropView) {
                /// When Exited Clearing the old Selected Image
                selectedImage = nil
            } content: {
                CropView(crop: selectedCropType, image: selectedImage) { croppedImage, status in
                    if let croppedImage {
                        self.croppedImage = croppedImage
                    }
                }
            }
    }
}

struct CropView: View {
    var crop: Crop
    var image: UIImage?
    /// This callback will give the cropped image and result status when the checkmark button is pressed.
    var onCrop: (UIImage?, Bool) -> ()
    
    /// View Properties
    @Environment(\.dismiss) private var dismiss
    /// Gesture Properties
    @State private var scale:CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOffset: CGSize = .zero
    /// Indicates whether or not the gesture is in interaction.
    @GestureState private var isInteracting: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ImageView()
                .navigationTitle("Crop View")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(.visible, for: .navigationBar)
                .toolbarBackground(Color.black, for: .navigationBar)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background {
                    Color.black
                        .ignoresSafeArea()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                                /// Converting View to Image (Native iOS 16+)
                            let rendere = ImageRenderer(content: ImageView(true))
                            rendere.proposedSize = .init(crop.size())
                            if let image =  rendere.uiImage {
                                onCrop(image, true)
                            } else {
                                onCrop(nil, false)
                            }
                            dismiss()
                        } label: {
                            Image(systemName: "checkmark")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                    }
                    ToolbarItem(placement: .topBarLeading) {
                        
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                                .font(.callout)
                                .fontWeight(.semibold)
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    func ImageView(_ hideGrids: Bool = false) -> some View {
        let cropSize = crop.size()
        GeometryReader {
            let size = $0.size
            
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay {
                        GeometryReader { proxy in
                            let rect = proxy.frame(in: .named("CROPVIEW"))
                            
                            Color.clear
                            /// So since I used overlay before the frame(), it will give the image natural size, thus helping us find its edges (top, left, right, and bottom). CoordinateSpace ensures that it will calculate its rect from the given view and not from the alobal view.
                                .onChange(of: isInteracting) { oldValue, newValue in
                                    /// true  Dragging
                                    /// false Stopped Dragging
                                    /// With the Help of GeometryReader
                                    /// we can now read the minX, Y and maxX, Y of the Image
                                    withAnimation(.easeInOut(duration: 0.2)) {
                                        if rect.minX > 0 {
                                            /// Resetting to Last Location
                                            offset.width = (offset.width - rect.minX)
                                            haptics(.medium)
                                        }
                                        if rect.minY > 0 {
                                            /// Resetting to Last Location
                                            offset.height = (offset.height - rect.minY)
                                            haptics(.medium)
                                        }
                                        
                                        /// Doing the same for maxX, Y
                                        if rect.maxX < size.width {
                                            /// Resetting to Last Location
                                            offset.width = (rect.minX - offset.width)
                                            haptics(.medium)
                                        }
                                        
                                        if rect.maxY < size.height {
                                            /// Resetting to Last Location
                                            offset.height = (rect.minY - offset.height)
                                            haptics(.medium)
                                        }
                                    }
                                    if !newValue {
                                        /// So why not simply use onEnded) instead of this? Because of my usage, onEnd() does not always call, but updating) is called whenever a gesture is updated, so l didn't use onEnded). racting, body: { _, out, _ in
                                        lastStoredOffset = offset
                                    }
                                }
                        }
                    }
                    .frame(size)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .overlay {
            /// We Don't Need Grid View for Cropped Image
            if !hideGrids {
                Grids()
            }
        }
        .coordinateSpace(name: "CROPVIEW")
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(width: translation.width + lastStoredOffset.width, height: translation.height + lastStoredOffset.height)
                })
        )
        .gesture(
            MagnifyGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let updatedScale = value.magnification + lastScale
                    /// Limiting Beyond 1
                    scale = (updatedScale < 1 ? 1: updatedScale)
                })
                .onEnded({ value in
                    withAnimation(.easeInOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .frame(cropSize)
        .clipShape(.rect(cornerRadius: crop == .circle ? cropSize.height / 2 : 0 ))
    }
    
    @ViewBuilder
    func Grids() -> some View {
        ZStack {
            HStack {
                ForEach(1...5, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(width: 1)
                        .frame(maxWidth: .infinity)
                }
            }
            
            VStack {
                ForEach(1...8, id: \.self) { _ in
                    Rectangle()
                        .fill(.white.opacity(0.7))
                        .frame(height: 1)
                        .frame(maxHeight: .infinity)
                    
                }
            }
        }
    }
}

#Preview {
    CropView(crop: .circle, image: UIImage(named: "Sample Pic")) { _, _ in
        
    }
}
