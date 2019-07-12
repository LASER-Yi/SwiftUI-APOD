//
//  ApodBlockView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ApodBlockView : View {
    let apod: ApodResult
    
    let frameWidth: CGFloat = 340.0
    let frameHeight: CGFloat = 380.0
    
    @State var isPresent: Bool = false
    
    @State var loadedImage: UIImage? = nil
    
    var modal: Modal {
        let view = ApodModalView(apod: apod, loadedImage: $loadedImage)
        
        
        let modalView = Modal(view) {
            self.isPresent = false
        }
        
        
        return modalView
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if apod.mediaType == .Image {
                AsyncImage(url: apod.url!, image: $loadedImage)
                    .frame(width: frameWidth, height: frameHeight)
                    .clipped()
                    .background(Color.init(white: 0.3))
            }else {
                Text("Video Content")
                    .color(.primary)
                    .frame(width: frameWidth, height: frameHeight)
                    .background(Color.secondary)
            }
            
            VStack {
                VStack(spacing: 4) {
                    Text(apod.getFormatterDate())
                        .font(.headline)
                        .color(.init(white: 0.8))
                    
                        Text(apod.title)
                            .font(.title)
                            .color(Color.white)
                            .bold()
                            .lineLimit(nil)
                            .multilineTextAlignment(.leading)
                    
                        }
                        .relativeWidth(1)
                        .padding(.leading, 12)
                        .padding(.trailing, 12)
                }
                .frame(width: frameWidth)
        }
        .presentation(isPresent ? modal : nil)
        .tapAction {
                self.isPresent = true
        }
        //.scaleEffect(isPresent ? 0.98 : 1.0)
        //.animation(.fluidSpring())
        .cornerRadius(8)
        .clipped()
        .shadow(radius: 6)
    }
}

#if DEBUG
struct ApodBlockView_Previews : PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32){
                ApodBlockView(apod: testArray[0])
                ApodBlockView(apod: testArray[1])
            }
            
        }
        
    }
}
#endif
