//
//  ApodModal.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/10.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct Article : View {
    
    var content: ApodData
    
    var mediaView: some View {
        Media(content: content)
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
            
            Badge(content: content.formattedDate)
            
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
            Article(content: debugContent[1])
            
            Article(content: debugContent[2])
                .preferredColorScheme(.dark)
        }
    }
}
#endif
