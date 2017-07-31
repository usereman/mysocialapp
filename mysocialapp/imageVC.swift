//
//  imageVC.swift
//  mysocialapp
//
//  Created by Abdullah Hafeez on 24/03/2017.
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import UIKit
import Firebase

class imageVC: UIViewController, UINavigationControllerDelegate{

    var getCaption = String()
    var getImage = UIImage()
    
    @IBOutlet weak var imgImage: UIImageView!
    @IBOutlet weak var lblCaption: UITextView!
    @IBOutlet weak var lblcaption2: UILabel!
    @IBOutlet weak var commentable: UITableView!
    var stringParsed : Int = 0
    var comments = [Comment]()
    var selectedPost : Post?
    var selectedImgUrl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgImage.image = getImage
        lblCaption.text! = "\(selectedPost!.caption)"
        selectedImgUrl = (selectedPost?.imageUrl)!
        
//        if img != nil{
//            self.imgImage.image = img
//        }else {
            let ref = Storage.storage().reference(forURL: selectedImgUrl)
            DataService.ds.SET_POST_IMAGE_URL(imURL: selectedImgUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil{
                    print("Unable to download image from firebase")
                } else{
                    print("Image downloaded successfully")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.imgImage.image = img
//                            imageVC.imageCache.setObject(img, forKey: selectedImgUrl as NSString)
                        }
                    }
                }
            })
        

        
        
        DataService.ds.REF_COMMENTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary< String, AnyObject>{
                        let key = snap.key
                        let strNtest: String = postDict["imageUrl"] as! String
                        print("THis: \(strNtest)")
                        //self.lblUsername.text = strNtest
                        
                        
                        let currentPost:String = (self.selectedPost?.imageUrl)!
                        
                        if( strNtest == currentPost ){
                            let comment = Comment(postKey: key , postData: postDict)
                            self.comments.append(comment)
                        }
                        
                    }
                }
            }
            self.commentable.reloadData()
        })
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return comments.count
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closeBtn(_ sender: Any) {
                self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
