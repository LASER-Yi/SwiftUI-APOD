//
//  SettingView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/11.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct SettingView : View {
    
    @EnvironmentObject var setting: UserSetting
    
    var apiEditor: some View {
        List {
            Section {
                TextEditor(text: $setting.apiKey)
            }
        }
        .listStyle(GroupedListStyle())
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink(destination: apiEditor) {
                        HStack {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                            Text("API Key")
                            
                            Spacer()
                            
                            Text(setting.apiKey)
                                .foregroundColor(.secondary)
                                .truncationMode(.tail)
                        }
                    }
                    
                    Toggle(isOn: $setting.loadHdImage) {
                        HStack {
                            Image(systemName: "map")
                            Text("HD Image")
                        }
                    }
                }
                
                Section {
                    Button(action: {
                        UIApplication.shared.open(Constants.GithubURL, options: [:], completionHandler: nil)
                    }) {
                        HStack {
                            Image(systemName: "heart")
                                .foregroundColor(.primary)
                            Text("Github")
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text("APOD-SwiftUI")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                }
            }
            .navigationBarTitle(Text("Settings"), displayMode: .inline)
        }
    }
}

#if DEBUG
struct SettingView_Previews : PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(UserSetting.shared)
    }
}
#endif
