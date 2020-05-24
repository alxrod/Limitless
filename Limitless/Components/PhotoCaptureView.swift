//
//  PhotoCaptureView.swift
//  ImageUploadTemplate
//
//  Created by Alex Rodriguez on 5/23/20.
//  Copyright © 2020 Alex Rodriguez. All rights reserved.
//

import SwiftUI

struct PhotoCaptureView: View {
    @Binding var showImagePicker : Bool
    @Binding var image : Image?
    
    @EnvironmentObject var session: FirebaseSession
       
    var body: some View {
        Group{
            Spacer()
            if session.session != nil {
                ImagePicker(isShown: $showImagePicker, image: $image, fbSession: session)
            }
            Spacer()
        }
    }
}

struct PhotoCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoCaptureView(showImagePicker: .constant(false), image:  .constant(Image("")))
    }
}
