//
//  AsyncImage.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/10.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI
import Combine

struct AsyncImage<Placeholder: View>: View {
    let url: URL
    
    @Binding var image: UIImage?
    
    var placeHolder: Placeholder
    
    @State private var loadTask: AnyCancellable? = nil
    
    init(url: URL, image: Binding<UIImage?> = .constant(nil), @ViewBuilder placeHolder: () -> Placeholder) {
        self.url = url
        self._image = image
        self.placeHolder = placeHolder()
    }
    
    var body: some View {
        VStack(alignment: .center) {
            if let image = self.image {
                Image(uiImage: image)
                    .resizable()
                    .transition(.opacity)
                    .animation(.easeInOut)
            }else {
                placeHolder
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .onAppear {
            self.loadImage()
        }
        .onDisappear {
            self.loadTask?.cancel()
            self.loadTask = nil
        }
    }
    
    private func loadImage() {
        let session = URLSession(configuration: .default)
        
        guard loadTask == nil && image == nil else { return }
        
        loadTask = session.dataTaskPublisher(for: url)
            .tryMap({ (data, response) -> UIImage in
                if let image = UIImage(data: data) {
                    return image
                }else {
                    throw URLError(.unknown)
                }
            })
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(_):
                    break
                default:
                    break
                }
            }, receiveValue: { (image) in
                withAnimation {
                    self.image = image
                }
            })

    }
}

#if DEBUG
struct AsyncImage_Previews : PreviewProvider {
    static var previews: some View {
        
        Group {
            
            AsyncImage(url: debugApodList[0].hdurl!) {
                ProgressView()
            }
            .frame(width: 300, height: 300)
            
            AsyncImage(url: debugApodList[1].hdurl!) {
                Text("We are preparing your APOD experience")
            }
            .padding()
            .border(Color.blue, width: 1.0)
            
        }
        .previewLayout(.sizeThatFits)
        

    }
}
#endif
