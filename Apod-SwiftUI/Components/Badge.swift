//
//  Badge.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/26.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import SwiftUI

struct Badge: View {
    
    let content: String
    
    var body: some View {
        Text(content)
            .font(.headline)
            .foregroundColor(.white)
            .padding([.leading, .trailing], 8)
            .padding([.top, .bottom], 2)
            .background(Color.secondary)
            .cornerRadius(8)
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge(content: "2021-10-31")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
