//
//  Interpolation.swift
//  Scrollable Tab Bar
//
//  Created by 엄기철 on 4/21/24.
//

import SwiftUI

/*다음으로, 매핑할 보간 기술이 필요합니다.
 주어진 출력 범위 값에 대한 입력 범위입니다. 을 위한
 예를 들어, 0.5의 진행률은 다음과 같은 경우 10으로 매핑됩니다.
 입력 범위는 [0, 0.5, 1]이고 출력 범위는 [0, 10, 15]입니다.
 입력 및 출력 범위 배열에 유의하십시오.
 이 기능이 작동하려면 개수가 일치해야 합니다.*/


extension CGFloat {
    func interpolate(inputRange: [CGFloat], outputRange: [CGFloat]) -> CGFloat {
        // 값이 초기 입력 범위보다 작은 경우
        let x = self
        let length = inputRange.count - 1
        if x <= inputRange[0] { return outputRange[0] }
        
        for index in 1...length {
            let x1 = inputRange[index - 1]
            let x2 = inputRange[index]
            
            let y1 = outputRange[index - 1]
            let y2 = outputRange[index]
            
            //선형 보간 공식: y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
            if x <= inputRange[index] {
                let y = y1 + ((y2 - y1) / (x2 - x1)) * (x - x1)
                return y
            }
        }
        // 값이 최대 입력 범위를 초과하는 경우
        return outputRange[length]
    }
}

