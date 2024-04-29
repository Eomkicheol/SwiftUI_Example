//
//  TabModel.swift
//  Scrollable Tab Bar
//
//  Created by 엄기철 on 4/21/24.
//

import Foundation

struct TabModel: Identifiable {
    /**
     크기와 minX 속성은 다음과 같습니다.
     동적 크기 조정 및 위치 지정에 사용됩니다.
     탭 표시줄의 표시기입니다.
     .**/
    private(set) var id: Tab
    var size: CGSize = .zero
    var minX: CGFloat = .zero
    
    enum Tab: String, CaseIterable {
        case research = "Research"
        case deployment = "Development"
        case analytics = "Analytics"
        case audience = "Audience"
        case privacy = "Privacy"
    }
}
