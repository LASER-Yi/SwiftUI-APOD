//
//  UserSetting.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/8/4.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import Foundation
import Combine

final class UserSetting: ObservableObject {
    
    private init() {}
    
    static let shared = UserSetting()
    
    @ConfigField(key: "ApiKey", defaultVal: "DEMO_KEY") var apiKey: String
    
    @ConfigField(key: "AutoHdImage", defaultVal: true) var loadHdImage: Bool
}
