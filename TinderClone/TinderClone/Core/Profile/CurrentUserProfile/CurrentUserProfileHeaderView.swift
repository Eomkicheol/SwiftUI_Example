//
//  CurrentUserProfileHeaderView.swift
//  TinderClone
//
//  Created by 엄기철 on 5/9/24.
//

import SwiftUI

struct CurrentUserProfileHeaderView: View {
    let user: User
    var body: some View {
        VStack {
            ZStack(alignment: .topTrailing) {
                Image(user.profileImageURLs[0])
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                .clipShape(Circle())
                .background {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 128, height: 128)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                }
                
                Image(systemName: "pencil")
                    .imageScale(.small)
                    .foregroundStyle(.gray)
                    .background {
                        Circle()
                            .fill(.white)
                            .frame(width: 32, height: 32)
                    }
                    .offset(x: -8, y: 10)
            }
            Text("\(user.fullName), \(user.age)")
                .font(.title2)
                .fontWeight(.light)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 240)
    }
}

#Preview {
    CurrentUserProfileHeaderView(user: MockData.users[0])
}
