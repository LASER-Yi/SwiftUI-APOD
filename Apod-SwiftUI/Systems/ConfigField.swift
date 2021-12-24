//
//  ConfigField.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/25.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import Foundation

@propertyWrapper
struct ConfigField<T> {
    let key: String
    
    let defaultVal: T
    
    var wrappedValue: T {
        get {
            if let val = UserDefaults.standard.object(forKey: key) as? T {
                return val
            } else {
                UserDefaults.standard.set(defaultVal, forKey: key)
                return defaultVal
            }
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
