//
//  SwiftUI+Helper.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/26.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import Foundation
import SwiftUI

struct PreviewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environmentObject(UserSettings.shared)
        #if DEBUG
            .environmentObject(RuntimeData.preview)
        #endif
    }
}

extension View {
    func previewed() -> some View {
        modifier(PreviewModifier())
    }
    
    func erase() -> AnyView {
        AnyView(erasing: self)
    }
}
