//
//  ApodModal.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/10.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ApodModalView : View {
    
    let apod: ApodResult
    
    @Binding var loadedImage: UIImage?
    
    var body: some View {
        
        VStack(spacing: 0) {
            if apod.hdurl != nil {
                AsyncImage(url: apod.hdurl!, image: $loadedImage)
                    .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 400.0)
                    .clipped()
                    .edgesIgnoringSafeArea(.top)
                    .edgesIgnoringSafeArea(.leading)
                    .edgesIgnoringSafeArea(.trailing)
                    .background(Color.white)
            }else {
                WebView(request: .init(url: apod.url!))
                    .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 400.0)
                    .clipped()
            }
            
            
            List {
                VStack(alignment: .leading, spacing: 4) {
                    Text(apod.title)
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(2)
                    
                    Text(apod.getFormatterDate())
                        .font(.headline)
                        .color(.gray)
                }
                
                
                Text(apod.explanation)
                    .font(.body)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                
                if apod.copyright != nil {
                    Text("© \(apod.copyright!)")
                }
            }
        }
    }
}

#if DEBUG
struct ApodModal_Previews : PreviewProvider {
    static var previews: some View {
        ApodModalView(apod: testData, loadedImage: .constant(nil))
    }
}
#endif
