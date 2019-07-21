//
//  UserDefaults+Helper.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/21.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import Foundation


extension UserDefaults {
    enum UserKey: String {
        case ApiKey
        case AutoHdImage
    }
    
    static func saveCustomValue(for key: UserKey, value: Any) {
        self.standard.set(value, forKey: key.rawValue)
    }
    
    static func getCustomValue(for key: UserKey) -> Any? {
        self.standard.object(forKey: key.rawValue)
    }
}
