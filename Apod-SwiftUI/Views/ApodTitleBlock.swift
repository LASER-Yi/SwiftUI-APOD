//
//  ApodBlockView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ApodTitleBlock : View {
    let apod: ApodResult
    
    let frameWidth: CGFloat = 340.0
    let frameHeight: CGFloat = 300.0
    
    var body: some View {
        PresentationLink(destination: ApodModalView(apod: apod)) {
            VStack(spacing: 0) {
                if apod.mediaType == .Image {
                    AsyncImage(url: apod.url!, isLoaded: .constant(false))
                        .frame(width: frameWidth, height: frameHeight)
                        .clipped()
                        .background(Color.secondary)
                }else {
                    Text("Video Content")
                        .frame(width: frameWidth, height: frameHeight)
                        .background(Color.secondary)
                }
                
                VStack {
                    VStack(alignment: .leading) {
                            Text(apod.getFormatterDate())
                                .font(.headline)
                                .color(.secondary)
                        
                            Text(apod.title)
                                .font(.title)
                                .color(.white)
                                .bold()
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        
                            }
                            .relativeWidth(1)
                            .padding(.leading, 12)
                            .padding(.trailing, 12)
                            .padding(.bottom, 8)
                            .padding(.top, 8)
                    }
                    .frame(width: frameWidth)
                    .background(Color.gray)
            }
            .cornerRadius(8)
            .clipped()
            .shadow(radius: 6)
        }
    }
}

#if DEBUG
struct ApodBlockView_Previews : PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32){
                ApodTitleBlock(apod: testData)
                ApodTitleBlock(apod: testData)
            }
            
        }
        
    }
}
#endif
