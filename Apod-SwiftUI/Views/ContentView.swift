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
    
    @State var isAlertPresented = false
    
    @State var alert: Alert? = nil
    
    func makeAlert(title: String, msg: String) {
        alert = Alert(title: Text(title), message: Text(msg))
        isAlertPresented = true
    }
    
    var body: some View {
        TabbedView {
//            Text("Today")
//                .tabItem {
//                    VStack{
//                        Image(systemName: "skew")
//                        Text("Today")
//                    }
//                }
//                .tag(0)
            
            WaterfallView()
                .environmentObject(userData)
                .tabItem {
                    VStack{
                        Image(systemName: "skew")
                        Text("APOD")
                    }
                }
                .tag(1)
            
            SettingView()
                .environmentObject(userData)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Setting")
                    }
                }
                .tag(2)
        }
        .alert(isPresented: $isAlertPresented) { alert! }
        .onAppear{
            self.userData.delegate = self
        }
    }
}

extension ContentView: RequestDelegate {
    func requestError(_ error: ApodRequest.RequestError) {
        switch error {
        case .Other(let msg):
            makeAlert(title: "Error", msg: msg)
        case .UrlError(let error):
            makeAlert(title: "Network Error", msg: error.localizedDescription)
        default:
            break
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
