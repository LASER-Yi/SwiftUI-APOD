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
        }else if userData.isSelectEmpty {
            return ("tornado", "Empty")
        }else {
            return ("cloud.bolt", "Error")
        }
    }
    
    @EnvironmentObject var userData: UserData
    
//    lazy var localView: some View = {
//        WfCardList(apods: userData.localApods, loadMsg: loadMsg);
//    }()
//
//    lazy var randomView: some View = {
//        WfCardList(apods: userData.randomApods, loadMsg: loadMsg)
//    }()
//
//    lazy var savedView: some View = {
//        WfCardList(apods: userData.savedApods, loadMsg: loadMsg)
//    }()
    
//    var selectedView: some View {
//        switch userData.loadType {
//        case .recent:
//            return localView
//        case .random:
//            return randomView
//        case .saved:
//            return savedView
//        }
//    }
    
    var body: some View {
        ScrollView {
            WfHeader(reloadDelegate: reloadApod, loadState: $userData.isLoading)
                .environmentObject(userData)
                .padding(.bottom, 8)
                .zIndex(100.0)
                
            
            Picker(selection: $userData.loadType, label: Text("Mode")) {
                ForEach(UserData.ApodLoadType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 275)
            .zIndex(100)
            
            WfCardList(apods: $userData.localApods, loadMsg: loadMsg)
            .padding([.top, .bottom], 24)
            .opacity(userData.isLoading ? 0.6 : 1)
            
        }
        .onAppear {
            if self.userData.isSelectEmpty {
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


