//
//  ApodModal.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/10.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ArticleView : View {
    
    var content: ApodData
    
    @Binding var image: UIImage?
    
    var mediaView: some View {
        ApodMediaView(content: content, image: $image)
            .cornerRadius(8.0)
            .padding(.all, 12.0)
            .shadow(radius: 10)
    }
    
    var article: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(content.title)
                .font(.largeTitle)
                .bold()
                .lineLimit(nil)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(content.getFormatterDate())
                .font(.headline)
                .foregroundColor(.white)
                .padding(.all, 8)
                .background(Color.accentColor)
                .cornerRadius(8.0)
            
            Divider()
            
            Text(content.explanation)
                .padding(.bottom, 6)
                .font(.body)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            
            if let copyright = content.copyright {
                Text("© \(copyright)")
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding([.leading, .trailing, .bottom], 12)
    }
    
    var body: some View {
        VStack {
            mediaView
            ScrollView {
                article
                    .frame(maxHeight: .infinity)
            }
        }
    }
}

#if DEBUG
struct ApodModal_Previews : PreviewProvider {
    static var previews: some View {
        Group {
            ArticleView(content: debugApodList[1], image: .constant(nil))
            
            ArticleView(content: debugApodList[2], image: .constant(nil))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
