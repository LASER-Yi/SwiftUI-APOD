//
//  Header.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/14.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct WfHeader: View {
    
    var currentDateStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, dd"
        return formatter.string(from: .init())
    }
    
    var reloadDelegate: () -> ()
    
    @Binding var loadState: Bool
    
    @State var btnAngle = 180.0
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            Text(currentDateStr.uppercased())
                .font(.subheadline)
                .bold()
                .foregroundColor(.gray)
            
            HStack {
                Text("APOD")
                    .font(.largeTitle)
                    .bold()
                
                Spacer()
                
                Button(action: {
                    self.reloadDelegate()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                        .imageScale(.large)
                        .rotationEffect(Angle(degrees: self.loadState ? btnAngle : 0))
                        .animation(.easeInOut)
                        .disabled(self.loadState == true)
                        .onAppear {
                            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                                if self.loadState {
                                    self.btnAngle += 12.0
                                    self.btnAngle.formTruncatingRemainder(dividingBy: 360.0)
                                }else {
                                    self.btnAngle = 180.0
                                }
                            }
                        }
                }
            }
            
            Divider()
        }
        .padding()
        
    }
}

#if DEBUG
struct Header_Previews : PreviewProvider {
    static var previews: some View {
        WfHeader(reloadDelegate: {}, loadState: .constant(false) )
            .previewLayout(.sizeThatFits)
    }
}
#endif
