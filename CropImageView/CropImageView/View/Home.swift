//
//  Home.swift
//  CropImageView
//
//  Created by 엄기철 on 5/26/24.
//

import SwiftUI

struct Home: View {
    /// View Properties
    @State private var showPicker: Bool = false
    @State private var croppedImage: UIImage?
    var body: some View {
        NavigationStack {
            VStack {
                if let croppedImage {
                    Image(uiImage: croppedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 400)
                } else {
                    Text("No Image is Selected")
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .navigationTitle("Crop Image Picker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showPicker.toggle()
                    } label: {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.callout)
                    }
                    .tint(.black)
                }
            }
            .cropImagePicker(options: [.circle, .square, .rectangle,], show: $showPicker, croppedImage: $croppedImage)
        }
    }
}

#Preview {
    Home()
}
