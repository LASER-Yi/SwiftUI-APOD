//
//  ApodModal.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/10.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ApodModal : View {
    let apod: ApodResult
    
    var body: some View {
        
        VStack {
            AsyncImage(url: apod.hdurl!, isLoaded: .constant(false))
                .frame(maxWidth: UIScreen.main.bounds.width, minHeight: 400.0)
                .clipped()
                .edgesIgnoringSafeArea(.top)
                .edgesIgnoringSafeArea(.leading)
                .edgesIgnoringSafeArea(.trailing)
                .background(Color.white)
            
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
                    .frame(minHeight: 600)
                    .font(.body)
                    .relativeHeight(1)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

#if DEBUG
struct ApodModal_Previews : PreviewProvider {
    static var previews: some View {
        ApodModal(apod: testData)
    }
}
#endif
