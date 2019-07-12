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
    var color: UIColor
    
    let blur: Bool
    
    init(color: UIColor = .systemBackground, blur: Bool = false) {
        self.color = color
        self.blur = blur
        
        
    }
    
    func makeUIView(context: UIViewRepresentableContext<Background>) -> UIVisualEffectView {
        let view = UIVisualEffectView(frame: .zero)
        
        if blur {
            let blurEffect = UIBlurEffect(style: .regular)
            view.effect = blurEffect
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Background>) {
        uiView.backgroundColor = color
        
    }
}

#if DEBUG
struct Background_Previews : PreviewProvider {
    static var previews: some View {
        Background()
    }
}
#endif
