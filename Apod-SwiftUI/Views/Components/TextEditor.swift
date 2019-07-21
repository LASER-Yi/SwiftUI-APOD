//
//  TextEditor.swift
//  Apod-SwiftUI
//
//  Created by LiangYi on 2019/7/22.
//  Copyright © 2019 LiangYi. All rights reserved.
//

import SwiftUI

struct TextEditor: View {
    @Binding var original: String
    
    @State var copy: String = ""
    
    var body: some View {
        List {
            Section {
                TextField($copy)
            }
            
            Section {
                Button(action: {
                    self.original = self.copy
                }) {
                    Text("Update")
                }
            }
        }
//        .onDisappear{
//            self.original = self.copy
//        }
        .onAppear{
            self.copy = self.original
        }
        
    }
}

#if DEBUG
struct TextEditor_Previews: PreviewProvider {
    static var previews: some View {
        TextEditor(original: .constant("Editor"))
    }
}
#endif
