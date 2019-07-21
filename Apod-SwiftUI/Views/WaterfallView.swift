//
//  WaterfallView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/11.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct WaterfallView : View, ApodRequester {
    
    func handleRequestError(_ msg: String) {
        loadMsg = ("cloud.bolt", msg)
    }
    
    func reloadApod() {
        if !userData.isLoading {
            loadMsg = ("cloud.rain", "Loading")
            
            self.userData.requestApod(self)
        }
    }
    
    @State var loadMsg: (String?, String?) = ("cloud.rain" ,"Loading")
    
    @EnvironmentObject var userData: UserData
    
    var selected: Binding<[ApodResult]> {
        switch userData.loadType {
        case .recent:
            return $userData.localApods
        case .random:
            return $userData.randomApods
        case .saved:
            return $userData.savedApods
        }
    }
    
    var body: some View {
        ScrollView {
            WfHeader(reloadFunc: reloadApod)
                .environmentObject(userData)
                .padding(.bottom, 8)
                .animation(nil)
                .zIndex(100)
            
            SegmentedControl(selection: $userData.loadType) {
                
                ForEach(UserData.ApodLoadType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .relativeWidth(0.75)
            .animation(nil)
            .zIndex(100)
            
            if !self.selected.isEmpty {
                WfCardList(apods: selected)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                    .opacity(userData.isLoading ? 0.6 : 1)
                    .animation(.easeInOut)
                    
            }else {
                Placeholder(
                    systemName: $loadMsg.0,
                    showTitle: $loadMsg.1)
                    .padding(.top, 200)
            }
            
        }
        .onAppear {
            self.reloadApod()
        }
        
    }
}



#if DEBUG
struct WaterfallView_Previews : PreviewProvider {
    static var previews: some View {
        WaterfallView()
            .environmentObject(UserData.test)
    }
}
#endif


