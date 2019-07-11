//
//  ContentView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        TabbedView {
            WaterfallView()
                .tag("waterfall")
                .environmentObject(userData)
                .tabItem {
                    VStack{
                        Image(systemName: "skew")
                        Text("APOD")
                    }
                }
            
            SettingView()
                .tag("setting")
                .environmentObject(userData)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Setting")
                    }
            }
        }
    }
    
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(UserData())
    }
}
#endif
