//
//  ErrorView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/12.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ErrorView : View {
    
    var error: Error
    
    init(_ error: Error) {
        self.error = error
    }
    
    var body: some View {
        VStack {
            Image(systemName: "cloud.bolt")
                .colorMultiply(.secondary)
                .imageScale(.large)
                .padding([.top, .bottom], 4)
            
            Text(error.localizedDescription)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity)
                .lineLimit(nil)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing])
            
        }
    }
}

#if DEBUG
struct ErrorView_Previews : PreviewProvider {
    static var previews: some View {
        ErrorView(URLError(.cannotFindHost))
    }
}
#endif
