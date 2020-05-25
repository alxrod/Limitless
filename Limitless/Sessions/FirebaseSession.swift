//
//  FirebaseSession.swift
//  ImageUploadTemplate
//
//  Created by Alex Rodriguez on 5/23/20.
//  Copyright © 2020 Alex Rodriguez. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase


class FirebaseSession: ObservableObject {
    @Published var session: User?
    @Published var isLoggedIn: Bool?
    @Published var imageThumbnails: [String: UIImage] = [:]
    var storageRef = Storage.storage().reference()
    var imageGraphicUpdate: (_ key: String, _ image:UIImage) -> Void = { (key, image) in print("You haven't implemented graphical handler yet") }
    var ref: DatabaseReference = Database.database().reference()
    
    func listen() {
        _ = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.session = User(uid: user.uid, displayName: user.displayName, email: user.email)
                self.isLoggedIn = true
                self.observeUserImages(uid: user.uid)
            } else {
                self.isLoggedIn = false
                self.session = nil
            }
        }
        
    }
    
    func observeUserImages(uid: String) -> Void {
//      I observe the thumbnails for the name because they're uploaded after the original downsampled images
//       By finding the thumbnails in the db, its not perfect but it means it will never call for a thumbnail or original that doesnt exist in the db
        
        _ = ref.child("users/"+uid+"/photos").observe(DataEventType.value, with: { (snapshot) in
            let imagesDict = snapshot.value as? [String : AnyObject] ?? [:]
            var index=0;
            for (fbKey, imgKey) in imagesDict {
                if let img = imgKey as? String {
                    if self.imageThumbnails.keys.contains(img) == false {
                        if let user = self.session {
                            if (index == imagesDict.keys.count-1) {
                                self.grabThumbnailById(uid: user.uid, iid: img, endBatch: true)
                            } else {
                                self.grabThumbnailById(uid: user.uid, iid: img)
                            }
                            
                        }
                    }
                    
                }
                index+=1
            }
            print(self.imageThumbnails.keys)
        })
    }
    
    func logIn(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password,completion: handler)
    }
    
    func logOut() {
        try! Auth.auth().signOut()
        self.isLoggedIn = false
        self.session = nil
    }
    
    func signUp(email: String, password: String, handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            print("Signup callback")
            if let callbackResp = result {
                let local_user = User(uid: callbackResp.user.uid, displayName: callbackResp.user.email, email: callbackResp.user.email)
                self.createUserInRTDB(user: local_user)
            }
            handler(result, error)
        }
    }
    
    func uploadImage(image: UIImage, thumbnail: Bool, iid: String?) -> String? {
        if let cUser = self.session {
            var subfolder = ""
            if thumbnail == false {
                subfolder = "originals"
            } else {
                subfolder = "thumbnails"
            }
            let imageId: String = iid ?? UUID().uuidString

        
            if let imgData = image.pngData() {
                let imgRef = self.storageRef.child("/" + cUser.uid + "/" + subfolder + "/" + imageId)
                let uploadTask = imgRef.putData(imgData, metadata: nil) { (metadata, error) in
                    guard let metadata = metadata else {
                        return
                    }
                
                    let size = metadata.size
                    if (thumbnail==false) {
                        self.ref.child("users/\(cUser.uid)/photos/").childByAutoId().setValue(imageId)
                    }
                       // You can also access to download URL after upload.
                    imgRef.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                           // Uh-oh, an error occurred!
                            return
                        }
                    }
                }
            } else {
                return nil
            }
            return imageId
        } else {
            return nil
        }
        
    }
    
    func createUserInRTDB(user: User) {
        if let user = self.session {
            self.ref.child("users/\(user.uid)/").setValue(["email":user.email,"friends":[],"images":[]])
        }
    }
    
    
    func grabThumbnailById(uid: String, iid: String, endBatch: Bool=false) {
        let imageRef = storageRef.child(uid+"/thumbnails/"+iid)

        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Get data error:")
                print(error)
                // Uh-oh, an error occurred!
            } else {
                // Data for "images/island.jpg" is returned
                if let image = UIImage(data: data!) {
                    print("Image parced successfuly")
                    self.imageThumbnails[iid]=image
                    self.imageGraphicUpdate(iid,image)

                }
                
            }
        }
    }
    
    func downloadFullImageSet(iids: [String], completion: @escaping (UIImage, Bool) -> Void) {
        if let user = self.session {
            for iid in iids {
                let imageRef = storageRef.child(user.uid+"/originals/"+iid)
                
                imageRef.getData(maxSize: 1 * 2048 * 2048) { data, error in
                    if let error = error {
                        print("Get data error:")
                        print(error)
                        // Uh-oh, an error occurred!
                    } else {
                        // Data for "images/island.jpg" is returned
                        if let image = UIImage(data: data!) {
                            if iids.index(of: iid) == (iids.count-1) {
                                completion(image, true)
                            } else {
                                completion(image, false)
                            }
//                            let imageSaver = ImageSaver()
//                            imageSaver.writeToPhotoAlbum(image: image)
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    }
                }
            }
        }
    }
}
