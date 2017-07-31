//
//  PostCell.swift
//  mysocialapp
//
//  Created by Abdullah Hafeez 
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var caption: UITextView!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var dislikesLbl: UILabel!
    @IBOutlet weak var upImg: UIImageView!
    @IBOutlet weak var downImg: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var imagetaappped: UIImageView!
    @IBOutlet weak var lblTimeStamp: UILabel!
    var commentBtnAction = {
        
    }
    
    
    var post: Post!
    var upRef: DatabaseReference!
    var downRef: DatabaseReference!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self , action: #selector(upTapped))
        tap.numberOfTapsRequired = 1
        upImg.addGestureRecognizer(tap)
        upImg.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self , action: #selector(downTapped))
        tap2.numberOfTapsRequired = 1
        downImg.addGestureRecognizer(tap2)
        downImg.isUserInteractionEnabled = true
        
        

        
    }
    
    
    func configureCell(post: Post, img : UIImage? = nil){
    self.post  = post
    upRef = DataService.ds.REF_USER_CURRENT.child("upvotes").child(post.postKey)
    downRef = DataService.ds.REF_USER_CURRENT.child("downvotes").child(post.postKey)
        
    self.lblUsername.text = post.username
    self.caption.text = post.caption
    self.likesLbl.text = "\(post.upvotes)"
    self.dislikesLbl.text = "\(post.downvotes)"
    lblTimeStamp.text = post.timeStamp
        
        if img != nil{
        self.postImg.image = img
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
                        self.postImg.image = img
                        FeedVC.imageCache.setObject(img, forKey: post.imageUrl as NSString)
                        }
                    }
                }
            })
        }
        
        upRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.upImg.image = UIImage(named:"empty-vote")}
            else {
                self.upImg.image = UIImage(named:"upvoted-filled")
            }
        })
        downRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.downImg.image = UIImage(named:"downvote")}
            else {
                self.downImg.image = UIImage(named:"downvoted-filled")
            }
        })
    }
    func upTapped(sender: UITapGestureRecognizer){
        upRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.upImg.image = UIImage(named:"upvoted-filled")
                self.post.adjustvotes(addvote: true)
                self.upRef.setValue(true)
            } else {
                self.upImg.image = UIImage(named:"empty-vote")
                self.post.adjustvotes(addvote: false)
                self.upRef.removeValue()
            }
        })
 }
    func downTapped(sender: UITapGestureRecognizer){
        downRef.observeSingleEvent(of: .value, with: {(snapshot) in
            if let _ = snapshot.value as? NSNull {
                self.downImg.image = UIImage(named:"downvoted-filled")
                self.post.adjustvotes2(addvote: true)
                self.downRef.setValue(true)
            } else {
                self.downImg.image = UIImage(named:"downvote")
                self.post.adjustvotes2(addvote: false)
                self.downRef.removeValue()
            }
        })
    }
    
    @IBAction func openCommentView(sender: UIButton) {
        commentBtnAction()
        
    }
    @IBAction func openCommentView2(_ sender: Any) {
        commentBtnAction()
    }
    
}


