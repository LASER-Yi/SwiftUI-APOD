//
//  ApodCardList.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/12.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct WfCardList : View {
    
    @Binding var apods: [ApodResult]
    
    @State var loadMsg: (String, String)
    
    var body: some View {
        VStack{
            if apods.isEmpty {
                Placeholder(systemName: loadMsg.0, showTitle: loadMsg.1)
                    .padding(.top, 180)
            }else {
                ForEach(apods) { apod in
                    WfApodCard(apod: apod)
                        .padding([.top, .bottom])
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width - 24)
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
        ScrollView{
            WfCardList(apods: .constant(UserData.test.localApods),
                       loadMsg: ("cloud.rain" ,"Loading") )
        }
    }
}
#endif
