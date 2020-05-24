//
//  ImagePicker.swift
//  ImageUploadTemplate
//
//  Created by Alex Rodriguez on 5/23/20.
//  Copyright © 2020 Alex Rodriguez. All rights reserved.
//

import SwiftUI
import UIKit
import CoreImage

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var isShown: Bool
    @Binding var image: Image?
    var fbSession: FirebaseSession
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>)
    {

    }
    func makeCoordinator() -> ImagePickerCoordinator{
        return ImagePickerCoordinator(isShown: $isShown, image: $image, sess: fbSession)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController
    {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker

    }
}

class ImagePickerCoordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @Binding var isShown : Bool
    @Binding var image: Image?
    var thumbnailScale: CGFloat = 100
    var fbSession: FirebaseSession
    
    init(isShown: Binding<Bool>, image:Binding<Image?>, sess: FirebaseSession) {
        _isShown = isShown
        _image = image
        fbSession = sess
    }
//Selected Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        image = Image(uiImage: uiImage)
        
       
        
//       Keys are: ["inputImage", "inputScale", "inputAspectRatio", "inputB", "inputC"]
        
        if let user = fbSession.session {
            let context = CIContext(options: nil)
            if let currentFilter = CIFilter(name: "CIBicubicScaleTransform") {
                let beginImage = CIImage(image: uiImage)
                currentFilter.setValue(beginImage, forKey: "inputImage")
                currentFilter.setValue(0.25, forKey: "inputScale")

                if let output = currentFilter.outputImage {
                    if let cgimg = context.createCGImage(output, from: output.extent) {
                        let processedImage = UIImage(cgImage: cgimg)
                        image = Image(uiImage: processedImage)
                        print("After size:")
                        print(processedImage.size)
                        let imageId = UUID().uuidString
                        if let uid = fbSession.uploadImage(image: processedImage, thumbnail: false, iid: imageId) {
                            print("Upload success")
                        } else {
                            print("Upload error occured")
                        }
                        let thumbnail = processedImage.resizeImage(thumbnailScale, opaque: true)
                        if let uid = fbSession.uploadImage(image: thumbnail, thumbnail: true, iid: imageId) {
                            print("Upload thumbnail success")
                        } else {
                            print("Upload error occured")
                        }
                        
                        // do something interesting with the processed image
                    }
                }
            }
        }
        
        isShown = false
   
    }
//Image selection got cancel
    func imagePickerControllerDidCancel(_ picker:      UIImagePickerController) {
        isShown=false
    }
}
