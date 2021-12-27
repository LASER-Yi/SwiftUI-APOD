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
    
    @State var selection = "Today"
    
    var body: some View {
        TabView(selection: self.$selection) {
            RandomView()
                .tabItem(systemName: "sparkles.rectangle.stack", text: "Gallery")
            
            TodayView()
                .tabItem(systemName: "skew", text: "Today")
            
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
