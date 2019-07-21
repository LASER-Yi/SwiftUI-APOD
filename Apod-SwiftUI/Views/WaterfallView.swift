//
//  WaterfallView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/11.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct WaterfallView : View {
    
    func reloadApod() {
        if !userData.isLoading {
            self.userData.requestApod()
        }
    }
    
    var loadMsg: (String, String) {
        if userData.isLoading {
            return ("cloud.rain" ,"Loading")
        }else if selected.isEmpty {
            return ("tornado", "Empty")
        }else {
            return ("cloud.bolt", "Error")
        }
    }
    
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
            .frame(width: 275)
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
                    systemName: loadMsg.0,
                    showTitle: loadMsg.1)
                    .padding(.top, 180)
            }
            
        }
        .onAppear {
            if self.selected.isEmpty {
                self.reloadApod()                
            }
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


