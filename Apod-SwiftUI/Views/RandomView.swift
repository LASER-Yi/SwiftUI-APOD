//
//  RandomView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/26.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import SwiftUI

struct RandomView: View {
    
    @EnvironmentObject var runtime: RuntimeData
    
    var body: some View {
        LoadableContent(source: runtime.randoms) { data in
            List {
                ForEach(data) { apod in
                    Card(apod: apod)
                }
            }
        }
    }
}

struct RandomView_Previews: PreviewProvider {
    static var previews: some View {
        RandomView()
            .previewed()
    }
}
