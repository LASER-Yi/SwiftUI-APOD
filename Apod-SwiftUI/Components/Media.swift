//
//  Media.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2020/6/27.
//  Copyright © 2020 LiangYi. All rights reserved.
//

import SwiftUI

struct Media: View {
    
    @EnvironmentObject var runtime: RuntimeData
    
    var content: ApodData
    
    var body: some View {
        VStack {
            if content.mediaType == .image {
                AsyncImage(url: content.imageUrl) { image in
                    image
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFill()
                        .onAppear {
                            runtime.previewingImage = image
                        }
                        .onDisappear {
                            runtime.previewingImage = nil
                        }
                        .onTapGesture {
                            runtime.isPreviewing = true
                        }
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200, alignment: .center)

            }else {
                WebView(request: URLRequest(url: content.url!))
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct ApodMediaView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Media(content: debugContent[0])
                .previewed()
                .previewLayout(.sizeThatFits)
        }
    }
}
