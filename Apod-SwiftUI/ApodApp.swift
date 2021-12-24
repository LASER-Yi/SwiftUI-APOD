//
//  ContentView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

@main
struct ApodApp : App {
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(RuntimeData.shared)
        }
    }
}
