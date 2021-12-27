//
//  UserSetting.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/8/4.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

final class UserSettings: ObservableObject {
    
    private init() {}
    
    static let shared = UserSettings()
    
    @AppStorage("ApiKey") var apiKey: String = "DEMO_KEY"
    
    @AppStorage("AutoHdImage") var loadHdImage = true
}
