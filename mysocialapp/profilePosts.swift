//
//  profilePosts.swift
//  mysocialapp
//
//  Created by Abdullah Hafeez on 03/04/2017.
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import UIKit
import Firebase

class profilePosts: UICollectionViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    
    
    
    var post: Post!
    var upRef: DatabaseReference!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(post: Post, img : UIImage? = nil){
        self.post  = post
        upRef = DataService.ds.REF_USER_CURRENT.child("upvotes").child(post.postKey)
        
        //self.lblUsername.text = post.username
        self.postLabel.text = post.caption
        //self.likesLbl.text = "\(post.upvotes)"
        
        if img != nil{
            self.imageview.image = img
        }else {
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            DataService.ds.SET_POST_IMAGE_URL(imURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data, error) in
                if error != nil{
                    print("Unable to download image from firebase")
                } else{
                    print("Image downloaded successfully")
                    if let imgData = data {
                        if let img = UIImage(data: imgData) {
                            self.imageview.image = img
                            profileViewer.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
       /*
        upRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.upImg.image = UIImage(named:"empty-vote")}
            else {
                self.upImg.image = UIImage(named:"upvoted-filled")
            }
        })
 */
    }

}
