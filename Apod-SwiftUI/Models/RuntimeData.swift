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
    
    var previewingImage: Image? = nil
    
    var isPreviewing = false
    
    var today: TodayApod = .init()
    
    var randoms: RandomApod = .init()
}
