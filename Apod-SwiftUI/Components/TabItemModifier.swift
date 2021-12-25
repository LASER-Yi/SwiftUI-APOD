//
//  TabItemModifier.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/26.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import SwiftUI

struct TabItemModifier: ViewModifier {
    
    let image: Image
    let text: String
    
    init(systemName: String, text: String) {
        self.image = Image(systemName: systemName)
        self.text = text
    }
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                VStack {
                    image
                    Text(text)
                }
            }
            .tag(text)
    }
}

extension View {
    func tabItem(systemName: String, text: String) -> some View {
        modifier(TabItemModifier(systemName: systemName, text: text))
    }

}
