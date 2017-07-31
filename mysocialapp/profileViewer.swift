//
//  profileViewer.swift
//  mysocialapp
//
//  Created by Abdullah Hafeez on 04/04/2017.
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import UIKit
import Firebase

class profileViewer: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    

    @IBOutlet weak var collectionview1: UICollectionView!
    
    
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionview1.delegate = self
        collectionview1.dataSource = self
        
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary< String, AnyObject>{
                        let key = snap.key
                        let strNtest: String = postDict["username"] as! String
                        print("THis: \(strNtest)")
                        
                        
                        let currentUser:String = self.getCurrentUser()
                        
                        if( strNtest == currentUser ){
                            let post = Post(postKey: key , postData: postDict)
                            self.posts.append(post)
                        }
                        
                    }
                }
            }
            self.collectionview1.reloadData()
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 103, height: 111)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let post = posts[indexPath.row]
        
        let cellID = "FeedCell2"
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? profilePosts {
            
            if let img = FirstView.imageCache.object(forKey: post.imageUrl as NSString) { // this line and one more like this
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return profilePosts()
        }
        
        
    }
    
    //Custome Method for Getting Current User
    
    func getCurrentUser() -> String {
        var currentUser:String = (Auth.auth().currentUser?.email)!
        
        if let range = currentUser.range(of: "@") {
            let firstPart = currentUser[currentUser.startIndex..<range.lowerBound]
            currentUser = firstPart
        }
        
        return currentUser
    }
    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
