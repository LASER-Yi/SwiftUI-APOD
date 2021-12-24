//
//  ImageViewer.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2020/7/3.
//  Copyright © 2020 LiangYi. All rights reserved.
//

import SwiftUI

struct ImageViewer: View {
    
    @State private var scale: CGFloat = 1.0;
    
    @State private var position: CGPoint = .init()
    
    @Binding var image: UIImage
    
    private var gesture: some Gesture {
        return self.drag
            .simultaneously(with: mag)
    }
    
    private var tap: some Gesture {
        return TapGesture()
    }
    
    private var drag: some Gesture {
        return DragGesture()
            .onChanged({ (state) in
                self.position.x += state.translation.width
                self.position.y += state.translation.height
            })
            .onEnded { (state) in
                // calc bounding box and try to reset
            }
    }
    
    private var mag: some Gesture {
        return MagnificationGesture()
            .onChanged { (state) in
                self.scale = state
            }
    }
    
    var body: some View {
        let size = CGSize(width: UIScreen.main.bounds.width * self.scale, height: (UIScreen.main.bounds.width * self.image.size.height / self.image.size.width) * self.scale)
        
        return GeometryReader{ geometry in
            Image(uiImage: self.image)
                .resizable()
                .gesture(self.gesture)
                .position(self.position)
                .frame(width: size.width, height: size.height)
                .preferredColorScheme(.dark)
                .onAppear {
                    let size = geometry.frame(in: .local).size
                    
                    var pos = CGPoint()
                    pos.x = size.width / 2.0
                    pos.y = size.height / 2.0
                    
                    self.position = pos
                }
        }
    }
}

struct ImageViewer_Previews: PreviewProvider {
    static var previews: some View {
        ImageViewer(image: .constant(UIImage.init(named: "preview") ?? UIImage.init()))
    }
}
