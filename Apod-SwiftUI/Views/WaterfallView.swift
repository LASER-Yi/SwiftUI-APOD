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
        loadMsg = ("icloud.slash", msg)
    }
    
    func reloadApod() {
        loadMsg = ("icloud", "Loading")
        
        self.userData.requestApod(self)
    }
    
    @State var loadMsg: (String, String) = ("icloud" ,"Loading")
    
    @EnvironmentObject var userData: UserData
    
    func selectedApods() -> [ApodResult] {
        switch userData.loadType {
        case .recent:
            return userData.localApods
        case .random:
            return userData.randomApods
        default:
            return []
        }
    }
    
    var body: some View {
        ScrollView {
            ApodHeader(requester: self)
                .environmentObject(userData)
                .padding(.bottom, 12)
            
            SegmentedControl(selection: $userData.loadType) {
                ForEach(UserData.ApodLoadType.allCases.identified(by: \.self)) {
                    type in
                    
                    Text(type.rawValue).tag(type)
                }
            }
            .padding(.leading, 48)
            .padding(.trailing, 48)
            
            if !self.selectedApods().isEmpty {
                ApodCardList(apods: self.selectedApods())
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                    .opacity(userData.needReload ? 0.5 : 1)
            }else {
                Placeholder(
                    systemName: userData.loadType != .saved ? loadMsg.0 : "heart.slash",
                    showTitle: userData.loadType != .saved ? loadMsg.1 : "Empty")
                    .padding(.top, 200)
            }
            
        }
        .onAppear {
            self.reloadApod()
        }
        
    }
}

struct ApodHeader: View {
    
    var currentDateStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, dd"
        return formatter.string(from: .init())
    }
    
    var requester: WaterfallView
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text(currentDateStr.uppercased())
                .font(.subheadline)
                .bold()
                .color(.gray)
            
            HStack {
                Text("APOD")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    self.requester.reloadApod()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .imageScale(.large)
                        .rotationEffect(Angle(degrees: userData.needReload ? 180 : 0))
                        .animation(.fluidSpring())
                        .disabled(userData.needReload == true)
                }
            }
            
            Divider()
        }
        .padding(.leading, 12)
            .padding(.trailing, 24)
            .padding(.top, 32)
        
    }
}

#if DEBUG
struct WaterfallView_Previews : PreviewProvider {
    static var previews: some View {
        WaterfallView()
            .environmentObject(UserData())
    }
}
#endif


