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
    
    private init() {}
    
    static let shared = RuntimeData()
    
    @Published var apods: [ApodRuntimeData] = []
    
    @Published var favoriteApods: Set<ApodRuntimeData> = .init()
    
//    @Published var today: ApodRuntimeData
    
}
