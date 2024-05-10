//
//  UserInfoview.swift
//  TinderClone
//
//  Created by 엄기철 on 5/8/24.
//

import SwiftUI

struct UserInfoview: View {
    @Binding var showProfileModal: Bool
    let user: User
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(user.fullName)
                    .font(.title)
                    .fontWeight(.heavy)
                
                Text("\(user.age)")
                    .font(.title)
                    .fontWeight(.semibold)
                    
                
                Spacer()
                
                Button(action: {
                    showProfileModal.toggle()
                }, label: {
                    Image(systemName: "arrow.up.circle")
                        .fontWeight(.bold)
                        .imageScale(.large)
                })
            }
            
            Text("Some test bio for now..")
                .font(.headline)
                .lineLimit(2)
        }
        .foregroundStyle(.white)
        .padding()
        .background(
            LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview {
    UserInfoview(showProfileModal: .constant(false), user: MockData.users[1])
}
