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
                .padding(.bottom, 4)
            
            Text(showTitle)
        }
    }
}

#if DEBUG
struct Placeholder_Previews : PreviewProvider {
    static var previews: some View {
        Placeholder(systemName: "icloud", showTitle: "Loading")
    }
}
#endif
