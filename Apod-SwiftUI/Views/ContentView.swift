//
//  ContentView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2020/6/25.
//  Copyright © 2020 LiangYi. All rights reserved.
//

import SwiftUI
import ImageViewer

struct ContentView: View {

    @EnvironmentObject var runtime: RuntimeData
    
    var body: some View {
        TabView {
            TodayView()
                .tabItem(systemName: "skew", text: "Today")
            
            RandomView()
                .tabItem(systemName: "wand.and.stars", text: "Random")
            
            SettingView()
                .tabItem(systemName: "gear", text: "Settings")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewed()
    }
}
