//
//  Card.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct Card : View {
    
    @State var apod: ApodData
    
    let aspect: CGFloat = 0.95
    
    let height: CGFloat = 350
    
    var width: CGFloat {
        height * aspect
    }
    
    @State var isPresent: Bool = false
    
    var modal: some View {
        Article(content: apod)
    }
    
    static let gradient = LinearGradient(gradient: .init(colors: [.init(white: 0.0, opacity: 0.75), .init(white: 0.0, opacity: 0.0)]), startPoint: .bottom, endPoint: .top)
    
    var header: some View {
        VStack(alignment: .leading , spacing: 4) {
            Badge(apod.formattedDate)
                
            Text(apod.title)
                .font(.title)
                .bold()
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        }
        .colorScheme(.dark)
        .padding([.leading, .trailing, .bottom], 12)
        .padding(.top, 24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Self.gradient)
    }
    
    var body: some View {
        VStack {
            if apod.mediaType == .image {
                AsyncImage(url: apod.url!)
                    .scaledToFill()
                    .frame(width: width, height: height)
                
            }else {
                Image(systemName: "video")
                    .imageScale(.large)
            }
        }
        .overlay(header, alignment: .bottomLeading)
        .sheet(isPresented: $isPresent, content: {
            self.modal
        })
        .onTapGesture {
                self.isPresent = true
        }
        .clipped()
        .frame(width: width, height: height)
        .cornerRadius(8)
        .shadow(radius: 6)
    }
}



#if DEBUG
struct Card_Previews : PreviewProvider {
    static var previews: some View {
        Group{
            ForEach(0..<2) { index in
                Card(apod: debugContent[index])
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
