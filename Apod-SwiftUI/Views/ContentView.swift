//
//  ContentView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2020/6/25.
//  Copyright © 2020 LiangYi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    enum NavigationItem: String, CaseIterable {
        case today = "Today"
        case random = "Random"
        case favorite = "Favorite"
    }
    
    var body: some View {
        TabView {
            TodayView()
                .tabItem(systemName: "skew", text: "Today")
            
            RandomView()
                .tabItem(systemName: "wand.and.stars", text: "Random")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
