//
//  WaterfallView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/11.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct WaterfallView : View {
    
    @EnvironmentObject var userData: UserData
    
    func reloadSelected() {
        UserData.shared.sendOnlineRequest(delegate: self, type: .refresh)
    }
    
    var selectedContent: Binding<[ApodBlockData]> {
        switch userData.currentLabel {
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
            WfHeader(reloadDelegate: reloadSelected, loadState: $userData.isLoading)
                .environmentObject(userData)
                .padding(.bottom, 8)
                .zIndex(100.0)
                
            
            Picker(selection: $userData.currentLabel, label: Text("Mode")) {
                ForEach(UserData.WfLabel.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 275)
            .zIndex(100)
                
            WfLoaderList(apodType: userData.currentLabel, contents: selectedContent)
            .padding([.top], 24)
            .opacity(userData.isLoading ? 0.6 : 1)
            
        }
    }
}

extension WaterfallView: RequestDelegate {
    func requestError(_ error: ApodRequest.RequestError) {
        
    }
    
    func requestSuccess(_ apods: [ApodBlockData], _ type: ApodRequest.LoadType) {
        if type == .refresh {
            selectedContent.value = apods
        }else {
            selectedContent.value.append(contentsOf: apods)
        }
    }
    
    
}



#if DEBUG
struct WaterfallView_Previews : PreviewProvider {
    static var previews: some View {
        WaterfallView()
        .environmentObject(UserData.shared)
    }
}
#endif


