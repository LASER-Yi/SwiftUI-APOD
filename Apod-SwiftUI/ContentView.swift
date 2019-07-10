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
        NavigationView{
            ScrollView {
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
            }
            .navigationBarTitle(Text("APOD"))
            .navigationBarItems(leading: Text(currentDateStr).font(.subheadline).bold().color(.gray))
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
