//
//  DebugContent.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/25.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

#if DEBUG
let asset = NSDataAsset(name: "list")!
let data = asset.data

let debugContent = try! JSONDecoder().decode(Array<ApodData>.self, from: data)
#endif


struct PreviewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .environmentObject(RuntimeData())
    }
}

extension View {
    func previewed() -> some View {
        modifier(PreviewModifier())
    }
}
