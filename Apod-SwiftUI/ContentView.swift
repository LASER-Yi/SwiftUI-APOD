//
//  ContentView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var currentDateStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, dd"
        return formatter.string(from: .init())
    }
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ScrollView {
            HStack{
                VStack(alignment: .leading) {
                    Text(currentDateStr.uppercased())
                        .font(.subheadline)
                        .bold()
                        .color(.gray)
                    Text("APOD")
                        .font(.largeTitle)
                        .bold()
                }
                
                Spacer()
                
                Button(action: {
                    self.userData.requestApod()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .imageScale(.large)
                        .disabled(userData.loadType == .recent || userData.needReload == true)
                }
            }
            .padding(.leading, 12)
            .padding(.trailing, 12)
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
            
            VStack(spacing: 32) {
                
                if userData.serverData.count == 0 {
                    VStack {
                        Image(systemName: "icloud")
                            .imageScale(.large)
                            .padding(.bottom, 4)
                        
                        Text("Loading")
                    }
                    .offset(x: 0, y: 200)
                }else {
                    ForEach(userData.serverData.identified(by: \.self)) { apod in
                        ApodBlockView(apod: apod)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .padding(.top, 24)
            .padding(.bottom, 24)
        }
        .onAppear {
            self.userData.requestApod()
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
