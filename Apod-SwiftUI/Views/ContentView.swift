//
//  ContentView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    
    var body: some View {
        TabView {
//            Text("Today")
//                .tabItem {
//                    VStack{
//                        Image(systemName: "skew")
//                        Text("Today")
//                    }
//                }
//                .tag(0)
                
            
            WaterfallView()
                .environmentObject(UserData.shared)
                .tabItem {
                    VStack{
                        Image(systemName: "skew")
                        Text("APOD")
                    }
                }
                .tag(1)
            
            SettingView()
                .environmentObject(UserSetting.shared)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Setting")
                    }
                }
                .tag(2)
        }
    }
}



#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            
            ContentView()
                .colorScheme(.dark)
        }
        
    }
}
#endif
