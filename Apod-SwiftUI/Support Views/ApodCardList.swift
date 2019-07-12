//
//  ApodCardList.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/12.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ApodCardList : View {
    
    var scaleTrans: AnyTransition {
        let insertion = AnyTransition
            .move(edge: .bottom)
            .combined(with: .opacity)
        
        let removal = AnyTransition
            .scale()
            .combined(with: .opacity)
        
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    let apods: [ApodResult]
    
    var body: some View {
        VStack(spacing: 32) {
            ForEach(apods.identified(by: \.self)) { apod in
                ApodBlockView(apod: apod)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
}

#if DEBUG
struct ApodCardList_Previews : PreviewProvider {
    static var previews: some View {
        ApodCardList(apods: UserData.default.localApods )
    }
}
#endif
