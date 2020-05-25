//
//  ImageGalleryWrapper.swift
//  Limitless
//
//  Created by Alex Rodriguez on 5/24/20.
//  Copyright © 2020 Zankner Rodriguez. All rights reserved.
//

import SwiftUI

struct ImageGalleryWrapper: View {
    @State var innerImage: Image
    
    var body: some View {
        VStack {
            GeometryReader { (geometry) in
                self.innerImage
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .padding(0)
            }
        }
    }
}

//struct ImageGalleryWrapper_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageGalleryWrapper(innerImage: <#T##Image#>)
//    }
//}
