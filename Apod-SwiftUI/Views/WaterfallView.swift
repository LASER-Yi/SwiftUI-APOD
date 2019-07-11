//
//  WaterfallView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/11.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct WaterfallView : View {
    var currentDateStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, dd"
        return formatter.string(from: .init())
    }
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ScrollView {
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
                        self.userData.requestApod()
                    }) {
                        Image(systemName: "arrow.2.circlepath.circle")
                            .imageScale(.large)
                            .rotationEffect(Angle(degrees: userData.needReload ? 180 : 0))
                            .animation(.fluidSpring())
                            .disabled(userData.loadType == .recent || userData.needReload == true)
                    }
                }
            }
            .padding(.leading, 12)
            .padding(.trailing, 24)
            .padding(.top, 32)
            
            Divider()
                .padding(.bottom, 12)
            
            SegmentedControl(selection: $userData.loadType) {
                ForEach(UserData.ApodLoadType.allCases.identified(by: \.self)) {
                    type in
                    
                    Text(type.rawValue).tag(type)
                }
            }
            .padding(.leading, 48)
            .padding(.trailing, 48)
            
            WaterfallCards(apods: $userData.serverData)
                .padding(.top, 24)
                .padding(.bottom, 24)
            
        }
        .onAppear {
            self.userData.requestApod()
        }
        
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

struct WaterfallCards : View {
    
    var scaleTrans: AnyTransition {
        let insertion = AnyTransition
            .move(edge: .bottom)
            .combined(with: .opacity)
        
        let removal = AnyTransition
            .scale()
            .combined(with: .opacity)
        
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    @Binding var apods: [ApodResult]
    
    var body: some View {
        VStack(spacing: 32) {
            if apods.isEmpty {
                VStack {
                    Image(systemName: "icloud")
                        .imageScale(.large)
                        .padding(.bottom, 4)
                    
                        Text("Loading")
                    }
                    .offset(x: 0, y: 200)
            }else {
                ForEach(apods.identified(by: \.self)) { apod in
                    ApodBlockView(apod: apod)
                }
                
            }
        }
        .frame(width: UIScreen.main.bounds.width)

    }
}
