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
    
    var body: some View {
        PresentationLink(destination: ApodModal(apod: apod)) {
            ZStack(alignment: .bottomLeading){
                if apod.mediaType == .Image {
                    AsyncImage(url: apod.url!, isLoaded: .constant(false))
                        .frame(width: frameWidth, height: frameHeight)
                        .background(Color.white)
                }else {
                    Text("Today is Video Content")
                        .frame(width: frameWidth, height: frameHeight)
                        .background(Color.white)
                }
                
                
                ZStack(alignment: .bottomLeading) {
                    Color(.sRGB, red: 0.2, green: 0.2, blue: 0.2, opacity: 0.6)
                        .frame(width: frameWidth, height: frameHeight*0.3)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(apod.getFormatterDate())
                            .font(.headline)
                            .color(.gray)
                        
                        Text(apod.title)
                            .font(.title)
                            .color(.white)
                            .bold()
                            .lineLimit(2)
                        
                    }
                    .frame(maxWidth: frameWidth, alignment: .leading)
                        .padding(.leading, 18)
                        .padding(.trailing, 18)
                        .padding(.bottom, 12)
                }
            }
            .cornerRadius(8)
                .clipped()
                .shadow(radius: 4)
        }
    }
}

#if DEBUG
struct ApodBlockView_Previews : PreviewProvider {
    static var previews: some View {
        ApodBlockView(apod: testData)
    }
}
#endif
