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
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("API Key")
                            .bold()
                        TextField("DEMO_KEY", text: $userData.apiKey)
                    }
                    
                    Toggle(isOn: $userData.loadHdImage) {
                        Text("Load HD Image")
                    }
                }
            }
            .navigationBarTitle(Text("Settings"))
        }
    }
}

#if DEBUG
struct SettingView_Previews : PreviewProvider {
    static var previews: some View {
        SettingView()
            .environmentObject(UserData())
    }
}
#endif
