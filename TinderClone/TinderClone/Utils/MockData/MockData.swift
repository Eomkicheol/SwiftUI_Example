//
//  MockData.swift
//  TinderClone
//
//  Created by 엄기철 on 5/8/24.
//

import Foundation


struct MockData {
    
    static let users: [User] = [
        .init(
            id: NSUUID().uuidString,
            fullName: "Megan Fox",
            age: 37,
            profileImageURLs: ["meganFox1", "meganFox2"],
            sex: "Woman"
        ),
        .init(
            id: NSUUID().uuidString,
            fullName: "David Beckham",
            age: 46,
            profileImageURLs: ["davidBeckham1", "davidBeckham2"],
            sex: "Man"
        ),
        .init(
            id: NSUUID().uuidString,
            fullName: "Conor Mcregor",
            age: 35,
            profileImageURLs: ["conorMcGregor1", "conorMcGregor2", "conorMcGregor3", "conorMcGregor4"],
            sex: "Man"
        )
    ]
}


extension MockData {
    static var matches: [Match] = [
        .init(
            id: UUID().uuidString,
            userId: users[0].id,
            timestamp: Date(),
            user: users[0]
        ),
        .init(
            id: UUID().uuidString,
            userId: users[2].id,
            timestamp: Date(),
            user: users[2]
        ),
        .init(
            id: UUID().uuidString,
            userId: users[1].id,
            timestamp: Date(),
            user: users[1]
        ),
    ]
}
