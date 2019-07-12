//
//  Placeholder.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/12.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct Placeholder : View {
    let systemName: String
    let showTitle: String
    
    var body: some View {
        VStack {
            Image(systemName: systemName)
                .imageScale(.large)
            
            Text(showTitle)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing])
        }
    }
}

#if DEBUG
struct Placeholder_Previews : PreviewProvider {
    static var previews: some View {
        Placeholder(systemName: "icloud", showTitle: "You have exceeded your rate limit. Try again later or contact us at https://api.nasa.gov:443/contact/ for assistance")
    }
}
#endif
