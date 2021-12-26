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
        NavigationView {
            LoadableContent(source: runtime.randoms) { data in
                ScrollView {
                    LazyVStack {
                        ForEach(data) { item in
                            Card(apod: item)
                                .padding([.vertical], 12)
                        }
                    }
                }
            }
            .navigationTitle(Text("Random"))
        }
    }
}

struct RandomView_Previews: PreviewProvider {
    static var previews: some View {
        RandomView()
            .previewed()
    }
}
