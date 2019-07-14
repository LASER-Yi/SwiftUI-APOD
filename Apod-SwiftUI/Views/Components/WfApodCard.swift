//
//  ApodBlockView.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/9.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct WfApodCard : View {
    @Binding var apod: ApodResult
    
    let aspect: Length = 0.95
    
    let height: Length = 350
    
    var width: Length {
        height * aspect
    }
    
    @State var isPresent: Bool = false
    
    @State var loadedImage: UIImage? = nil
    
    var modal: Modal {
        let view = ModalView(apod: $apod, loadedImage: $loadedImage)
        
        let modalView = Modal(view) {
            self.isPresent = false
        }
        
        return modalView
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            
            VStack {
                if apod.mediaType == .Image {
                    AsyncImage(url: apod.url!, image: $loadedImage)
                        .scaledToFill()
                        .animation(nil)
                    
                }else {
                    Image(systemName: "video")
                        .imageScale(.large)
                }
            }
            .frame(width: width, height: height)
            .background(Background(color: .systemGray5))
            
            
            
            VStack(alignment: .leading , spacing: 0) {
                
                Text(apod.getFormatterDate())
                    .font(.headline)
                    .color(.secondary)
                
                
                HStack {
                    Text(apod.title)
                        .font(.title)
                        .color(Color.white)
                        .bold()
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                
            }
            .padding([.leading, .trailing], 12)
            .padding([.top, .bottom], 6)
            .background(Background(color: .init(white: 0.4, alpha: 0.2), blur: true))
            
            
        }
        .presentation(isPresent ? modal : nil)
        .tapAction {
                self.isPresent = true
        }
        //.scaleEffect(isPresent ? 0.98 : 1.0)
        //.animation(.fluidSpring())
        .clipped()
        .frame(width: width)
        .cornerRadius(8)
        .shadow(radius: 6)

    }
}



#if DEBUG
struct ApodBlockView_Previews : PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 32){
                WfApodCard(apod: .constant(testArray[0]) )
                
                WfApodCard(apod: .constant(testArray[1]) )
                    .colorScheme(.dark)
            }
            .frame(width: UIScreen.main.bounds.width)
            
        }
    }
}
#endif
