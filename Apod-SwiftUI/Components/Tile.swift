//
//  Tile.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2021/12/27.
//  Copyright © 2021 LiangYi. All rights reserved.
//

import SwiftUI

struct Tile: View {
    
    let apod: ApodData
    
    var body: some View {
        GeometryReader { geometry in
            AsyncImage(url: apod.imageUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .center)
            .clipped(antialiased: false)
        }
    }
}

struct Tile_Previews: PreviewProvider {
    static var previews: some View {
        Tile(apod: debugContent.first!)
            .frame(width: 100, height: 100)
    }
}
