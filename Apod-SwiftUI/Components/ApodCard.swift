//
//  ApodBlockView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct ApodCard : View {
    
    @State var apod: ApodData
    
    enum DisplayMode {
        case full
        case compact
    }
    
    var displayMode: DisplayMode = .full
    
    let aspect: CGFloat = 0.95
    
    let height: CGFloat = 350
    
    var width: CGFloat {
        height * aspect
    }
    
    @State var isPresent: Bool = false
    
    var modal: some View {
        let view = Article(content: apod)
        
        return view
    }
    
    var header: some View {
        VStack(alignment: .leading , spacing: 4) {
            
            Text(apod.formattedDate)
                .font(.headline)
                .foregroundColor(.primary)
                .padding([.leading, .trailing], 8)
                .padding([.top, .bottom], 2)
                .background(Color.secondary)
                .cornerRadius(8)
                
            
            
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
        .background(LinearGradient(gradient: .init(colors: [.init(white: 0.0, opacity: 0.75), .init(white: 0.0, opacity: 0.0)]),
                                   startPoint: .bottom,
                                   endPoint: .top))
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
struct ApodBlockView_Previews : PreviewProvider {
    static var previews: some View {
        Group{
            ForEach(0..<4) { index in
                ApodCard(apod: debugContent[index])
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
