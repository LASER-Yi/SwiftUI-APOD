//
//  ApodMediaView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2020/6/27.
//  Copyright © 2020 LiangYi. All rights reserved.
//

import SwiftUI

struct ApodMediaView: View {
    
    var content: ApodData
    
    @Binding var image: UIImage?
    
    var body: some View {
        VStack {
            if content.mediaType == .image {
                AsyncImage(url: content.getImageUrl()!, image: $image) {
                    ProgressView()
                }
                    .scaledToFit()
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
            ApodMediaView(content: debugApodList[0], image: .constant(nil))
                .previewLayout(.sizeThatFits)
        }
    }
}
