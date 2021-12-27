//
//  TabItemModifier.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/26.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import SwiftUI

struct TabItemModifier: ViewModifier {
    
    let systemName: String
    let label: String
    
    init(systemName: String, label: String) {
        self.systemName = systemName
        self.label = label
    }
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                VStack {
                    Image(systemName: systemName)
                    Text(label)
                }
            }
            .tag(label)
    }
}

extension View {
    func tabItem(systemName: String, text: String) -> some View {
        modifier(TabItemModifier(systemName: systemName, label: text))
    }
}
