//
//  ApodModal.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/10.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ModalView : View {
    
    @Binding var apod: ApodResult
    
    @Binding var loadedImage: UIImage?
    
    var body: some View {
        
        VStack(spacing: 0) {
            VStack {
                if apod.mediaType == .Image {
                    AsyncImage(url: apod.hdurl!, image: $loadedImage)
                        .scaledToFit()
                        
                }else {
                    WebView(request: .init(url: apod.url!))
                }
            }
            .clipped()
            .frame(maxWidth: UIScreen.main.bounds.width, maxHeight: 400.0)
            
            
            Divider()
            
            
            List {
                VStack(alignment: .leading, spacing: 4) {
                    Text(apod.title)
                        .font(.largeTitle)
                        .bold()
                        .lineLimit(2)
                    
                    HStack {
                        Text(apod.getFormatterDate())
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Button(action: {
                            self.apod.favourite.toggle()
                        }) {
                            Image(systemName: self.apod.favourite ? "star.fill" : "star")
                                .imageScale(.small)
                                .foregroundColor(self.apod.favourite ? .yellow : .gray)
                        }
                    }
                    
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
        ModalView(apod: .constant(UserData.test.localApods.first!) , loadedImage: .constant(nil))
    }
}
#endif
