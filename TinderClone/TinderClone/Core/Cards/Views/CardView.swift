//
//  CardView.swift
//  TinderClone
//
//  Created by 엄기철 on 5/8/24.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var matchManager: MatchManager
    @ObservedObject var viewModel: CardsViewModel
    @State private var xOffset: CGFloat = 0
    @State private var degrees: Double = 0
    @State private var currentImageIndex = 0
    @State private var showProfileModal = false
    
    let model: CardModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack(alignment: .top) {
                Image(user.profileImageURLs[currentImageIndex])
                    .resizable()
                    .scaledToFill()
                    .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
                    .overlay {
                        ImageScrollingOverlay(currentImageIndex: $currentImageIndex, imageCount: imageCount)
                    }
                
                CardImageIndicatorView(currentImageIndex: currentImageIndex, imageCount: imageCount)
                
                SwipeActionIndicatorView(xOffset: $xOffset)
            }
            UserInfoview(showProfileModal: $showProfileModal, user: model.user)
        }
        .fullScreenCover(isPresented: $showProfileModal) {
           UserProfileView(user: user)
        }
        .onReceive(viewModel.$buttonSwipeAction, perform: { action in
            self.onReceiveSwipeAction(action)
        })
        .frame(width: SizeConstants.cardWidth, height: SizeConstants.cardHeight)
        .clipShape(.rect(cornerRadius: 10))
        .offset(x: xOffset)
        .rotationEffect(.degrees(degrees))
        .animation(.snappy, value: xOffset)
        .gesture(
            DragGesture()
                .onChanged(onDragChanged)
                .onEnded(onDragEnded)
        )
    }
}

private extension CardView {
    func retureCenter() {
        xOffset = 0
        degrees = 0
    }
    
    func swipeRight() {
        withAnimation {
            xOffset = 500
            degrees = 12
        } completion: {
            viewModel.removeCard(model)
            matchManager.checkForMatch(withUser: user)
        }
    }
    
    func swipeLeft() {
        withAnimation {
            xOffset = -500
            degrees = -12
        } completion: {
            viewModel.removeCard(model)
        }
    }
    
    func onReceiveSwipeAction(_ action: SwipeAction?) {
        guard let action else { return }
        
        let topCard = viewModel.cardModels.last
        
        if topCard == model {
            switch action {
            case .reject:
                swipeLeft()
            case .like:
                swipeRight()
            }
        }
    }
}

private extension CardView {
    var user: User {
        return model.user
    }
    
    var imageCount: Int {
        return user.profileImageURLs.count
    }
}

private extension CardView {
    func onDragEnded(_ value: _ChangedGesture<DragGesture>.Value) {
        let width = value.translation.width
        
        if abs(width) <= abs(SizeConstants.screenCutoff) {
            retureCenter()
            return
        }
        
        if width >= SizeConstants.screenCutoff {
            swipeRight()
        } else {
            swipeLeft()
        }
    }
    
    
    func onDragChanged(_ value: _ChangedGesture<DragGesture>.Value)  {
        xOffset = value.translation.width
        degrees = Double(value.translation.width / 25 )
    }
}



#Preview {
    CardView(
        viewModel: CardsViewModel(service: CardService()),
        model: CardModel(user: MockData.users[1])
    )
}
