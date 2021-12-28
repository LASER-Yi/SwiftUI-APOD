//
//  UserData.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

final class RuntimeData: ObservableObject {
    
    var today: TodayApod = .init()
    
    var randoms: RandomApod = .init()
    
    var time: TimeApod = .init()
    
    // Use for preview only
    #if DEBUG
    static var preview: RuntimeData {
        let data = RuntimeData()
        
        data.today.state = .loaded(debugContent[0])
        data.randoms.state = .loaded(debugContent)
        data.time.state = .loaded(debugContent)
        
        return data
    }
    #endif
}
