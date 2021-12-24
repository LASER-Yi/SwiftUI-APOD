//
//  ApodMediaView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2020/6/27.
//  Copyright © 2020 LiangYi. All rights reserved.
//

import SwiftUI

struct Media: View {
    
    var content: ApodData
    
    var body: some View {
        VStack {
            if content.mediaType == .image {
                AsyncImage(url: content.getImageUrl()) { image in
                    image
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: .infinity, height: 200, alignment: .center)
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
            Media(content: debugApodList[0])
                .previewLayout(.sizeThatFits)
        }
    }
}
