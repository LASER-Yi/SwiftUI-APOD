//
//  ApodCardList.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/12.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ApodBlockList : View {
    
    let apods: [ApodResult]
    
    var body: some View {
        VStack(spacing: 32) {
            ForEach(apods.identified(by: \.self)) { apod in
                ApodBlockView(apod: apod)
                    .transition(.opacity)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

struct ScaleAndFade: ViewModifier {
    /// True when the transition is active.
    var isEnabled: Bool
    
    // Scale and fade the content view while transitioning in and
    // out of the container.
    
    func body(content: Content) -> some View {
        return content
            .scaleEffect(isEnabled ? 0.1 : 1)
            .opacity(isEnabled ? 0 : 1)
    }
}

extension AnyTransition {
    static let scaleAndFade = AnyTransition.modifier(
        active: ScaleAndFade(isEnabled: true),
        identity: ScaleAndFade(isEnabled: false))
}

#if DEBUG
struct ApodCardList_Previews : PreviewProvider {
    static var previews: some View {
        ApodBlockList(apods: UserData.test.localApods )
    }
}
#endif
