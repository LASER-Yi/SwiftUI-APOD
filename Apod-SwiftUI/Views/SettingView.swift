//
//  SettingView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/11.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct SettingView : View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: TextEditor(original: $userData.apiKey)) {
                        HStack {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                            Text("API Key")
                            
                            Spacer()
                            
                            Text(userData.apiKey)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    
                    
                    Toggle(isOn: $userData.loadHdImage) {
                        HStack {
                            Image(systemName: "map")
                            Text("HD Image")
                        }
                    }
                }
                
                Section {
                    HStack {
                        Image(systemName: "heart")
                        Text("Github")
                        
                        Spacer()
                        
                        Text("APOD-SwiftUI")
                            .foregroundColor(.secondary)
                    }
                    
                }
            }
            .listStyle(.grouped)
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
        }
    }
}

#if DEBUG
struct SettingView_Previews : PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(UserData.test)
    }
}
#endif
