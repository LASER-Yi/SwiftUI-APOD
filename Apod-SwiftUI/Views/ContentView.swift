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
                .environmentObject(userData)
                .tabItem {
                    VStack{
                        Image(systemName: "skew")
                        Text("APOD")
                    }
                }
                .tag("waterfall")
            
            SettingView()
                .environmentObject(userData)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Setting")
                    }
                }
                .tag("setting")
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(UserData.test)
            
            ContentView()
                .environmentObject(UserData.test)
                .colorScheme(.dark)
        }
        
    }
}
#endif
