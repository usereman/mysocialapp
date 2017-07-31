//
//  addingimgVC.swift
//  mysocialapp
//
//  Created by Abdullah Hafeez 
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import UIKit
import Firebase

class addingimgVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate , UITextFieldDelegate{
    
    
    var imagePicker: UIImagePickerController!
    @IBOutlet weak var imageAdd: UIImageView!
    @IBOutlet weak var captionField: FancyField!
    
    var timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .short)
    
    var imageSelected = false
    var username :String = ""
    var timestampInSec :Int = 0
    
    override func viewDidLoad() {
        
        var name:String = (Auth.auth().currentUser?.email)!
        
        if let range = name.range(of: "@") {
            let firstPart = name[name.startIndex..<range.lowerBound]
            name = firstPart
        }
        
        username = name
        
        
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true

        imagePicker.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()


        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage{
            imageAdd.image = image
            imageSelected = true
        }else {
        print("A valid image was not selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    @IBAction func addImageTapped(_ sender: Any) {
    present(imagePicker,animated: true, completion: nil)
    }
    @IBAction func postBtnTapped(_ sender: Any) {
        guard let caption = captionField.text, caption != "" else {
            print("Caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true  else {
        print("Must select any image")
            return
        }
        if let imgData = UIImageJPEGRepresentation(img, 0.2){
        
        let imgUid = NSUUID().uuidString
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
            DataService.ds.REF_POST_IMAGES.child(imgUid).putData(imgData,metadata: metadata) {(metadata, error) in
                if error != nil {
                print("Unable to upload image to firebase storage")
                } else {
                print("image uploaded to firebase successfully")
                let downloadURL = metadata?.downloadURL()?.absoluteString
                if let url = downloadURL{
                self.postToFirebase(imgUrl: url)
                }
                }
            }
        
        }
    }
    func postToFirebase(imgUrl: String){
        let post: Dictionary<String, AnyObject> = [
            "username" : username as AnyObject ,
            "caption": captionField.text! as AnyObject,
            "imageUrl": imgUrl as AnyObject,
            "upvotes": 0 as AnyObject,
            "downvotes": 0 as AnyObject,
            "timeStamp": timestamp as AnyObject,
            "timestampInSec": Date().timeIntervalSince1970 as AnyObject
        ]
        let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
            firebasePost.setValue(post)
        
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
