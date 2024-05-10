//
//  CurrentUserProfileView.swift
//  TinderClone
//
//  Created by 엄기철 on 5/9/24.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @State private var showEditProfile = false
    let user: User
    var body: some View {
        NavigationStack {
            List {
                // Header
                CurrentUserProfileHeaderView(user: user)
                    .onTapGesture {
                        showEditProfile.toggle()
                    }
                
                // account info
                Section("Account Information") {
                    HStack {
                        Text("Name")
                        
                        Spacer()
                        
                        Text(user.fullName)
                    }
                    
                    HStack {
                        Text("Email")
                        
                        Spacer()
                        
                        Text("text@gmail.com")
                    }
                }
                
                // legal
                Section("Legal") {
                    Text("Terms of Service")
                        
                }
                
                // logout / delete
                Section {
                    Button("Logout") {
                        print("DEBUG: Logout here...")
                    }
                }
                .foregroundStyle(.red)
                
                Section {
                    Button("Delete Account") {
                        print("DEBUG: Delete account here...")
                    }
                }
                .foregroundStyle(.red)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .fullScreenCover(isPresented: $showEditProfile) {
                EditProfileView(user: user)
            }
        }
    }
}

#Preview {
    CurrentUserProfileView(user: MockData.users[0])
}
