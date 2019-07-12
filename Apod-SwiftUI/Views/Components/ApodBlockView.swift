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
        ZStack(alignment: .bottomLeading) {
            
            if apod.mediaType == .Image {
                AsyncImage(url: apod.url!, image: $loadedImage)
                    .frame(width: frameWidth, height: frameHeight)
                    .clipped()
                    .background(Background(color: .systemGray5))
            }else {
                Image(systemName: "video")
                    .imageScale(.large)
                    .frame(width: frameWidth, height: frameHeight)
                    .background(Background(color: .systemGray5))
            }
            
            VStack(alignment: .leading , spacing: 0) {
                Text(apod.getFormatterDate())
                    .font(.headline)
                    .color(.secondary)
                
                HStack {
                    Text(apod.title)
                        .font(.title)
                        .color(Color.white)
                        .bold()
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
            }
            .padding([.leading, .trailing], 12)
            .padding([.top, .bottom], 6)
            .background(Background(color: .init(white: 0.4, alpha: 0.2), blur: true))
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
                    .colorScheme(.dark)
            }
            
        }
        
    }
}
#endif
