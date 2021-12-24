//
//  Placeholder.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/12.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct Placeholder : View {
    
    var sfSymbol: String
    var content: String?
    
    var body: some View {
        VStack {
            Image(systemName: sfSymbol)
                .colorMultiply(.secondary)
                .imageScale(.large)
                .padding([.top, .bottom], 4)
            
            if content != nil {
                Text(content!)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity)
                    .lineLimit(nil)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing])
            }
            
        }
    }
}

#if DEBUG
struct Placeholder_Previews : PreviewProvider {
    static var previews: some View {
        Placeholder(sfSymbol: "cloud.bolt" , content: "You have exceeded your rate limit. Try again later or contact us at https://api.nasa.gov:443/contact/ for assistance")
    }
}
#endif
