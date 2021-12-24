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
    
    @Published var apods: [ApodData] = []
    
    @Published var favoriteApods: Set<ApodData> = .init()
    
//    @Published var today: ApodRuntimeData
    
}
