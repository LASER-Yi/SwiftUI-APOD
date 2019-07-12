//
//  Background.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/12.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import UIKit

struct Background : UIViewRepresentable {
    let color: UIColor
    
    let blur: Bool
    
    init(color: UIColor = .systemBackground, blur: Bool = false) {
        self.color = color
        self.blur = blur
    }
    
    func makeUIView(context: UIViewRepresentableContext<Background>) -> UIVisualEffectView {
        UIVisualEffectView(frame: .zero)
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Background>) {
        uiView.backgroundColor = color
        
        if blur {
            let blurEffect = UIBlurEffect(style: .regular)
            uiView.effect = blurEffect
        }
    }
}

#if DEBUG
struct Background_Previews : PreviewProvider {
    static var previews: some View {
        Background()
    }
}
#endif
