//
//  ApodModal.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/10.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ArticleView : View {
    
    @State var content: ApodData
    
    @Binding var loadedImage: UIImage?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 4) {
                Text(content.title)
                    .font(.largeTitle)
                    .bold()
                    .lineLimit(nil)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(content.getFormatterDate())
                    .font(.headline)
                    .foregroundColor(.gray)
                
            }
            
            
            Text(content.explanation)
                .padding([.top, .bottom], 24)
                .font(.body)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            
            if let copyright = content.copyright {
                Text("© \(copyright)")
                    .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 6)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding([.leading, .trailing], 12)
    }
}

#if DEBUG
struct ApodModal_Previews : PreviewProvider {
    static var previews: some View {
        ArticleView(content: debugApodList[1] , loadedImage: .constant(nil))
    }
}
#endif
