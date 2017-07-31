//
//  FeedVC.swift
//  mysocialapp
//
//  Created by Abdullah Hafeez 
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper
import Foundation


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var postss : [Post] = []
    
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var post: Post!
    var valueToPass:String!
   // static var imageCache: Cache<NSString, UIImage> = Cache() this line

    func score(upvotes: Int,downvotes:Int)-> Int{
        return upvotes-downvotes}
    
    
    func postvirality( upvotes: Int, downvotes: Int,timestamp:Int)->Int{
        var sign: Double = 0
        var s: Double = Double(score(upvotes: upvotes, downvotes: downvotes))
        
        var order = log10((max(abs(s),1)))
        
        if(s > 0){
            sign = 1}
            
        else if(s < 0){
            sign = -1}
            
        else{
            sign = 0}
        
        var seconds:Double = Double(timestamp - 1134028003)
        
        return Int(round(order + ((sign * seconds)/450000)))
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(Auth.auth().currentUser?.isEmailVerified == false){
            
            
            //check if child("username") is set
            
            print("abc : Yep")
            let temp = randomAlphaNumericString(length: 6)
            let temp2 = "user"+temp
            DataService.ds.REF_USER_CURRENT.child("username").setValue(temp2)
            print("itsUsername:-\(temp2)")
            
        } else {
            print("abc : verified")
            var name:String = (Auth.auth().currentUser?.email)!
            
            if let range = name.range(of: "@") {
                let firstPart = name[name.startIndex..<range.lowerBound]
                name = firstPart
            }
            
            print("abd:-\(name)")
            print(DataService.ds.REF_USER_CURRENT)
            DataService.ds.REF_USER_CURRENT.child("username").setValue(name)

        }
        

        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        DataService.ds.REF_POSTS.observe(.childAdded, with: { (snapshot) in
            print("SNAP: \(snapshot)")

            
            if let data = snapshot.value as? Dictionary<String,Any> {
                
                let key = snapshot.key
                let post = Post(postKey: key, postData: data)
                self.posts.append(post)
                
                self.posts.sort{ (post1, post2) -> Bool in
                    let post1Results = self.postvirality(upvotes: post1.upvotes, downvotes: post1.downvotes, timestamp: post1.timestampInSec)
                    let post2Results = self.postvirality(upvotes: post2.upvotes, downvotes: post2.downvotes, timestamp: post2.timestampInSec)
                    return post1Results > post2Results
                }

            }
            
            
            
//            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
//                for snap in snapshot{
//                print("SNAP: \(snap)")
//                if let postDict = snapshot.value as? Dictionary< String, AnyObject>{
//                let key = snap.key
//                let post = Post(postKey: key , postData: postDict)
//                    self.posts.append(post)
//                    //let temp3 = self.postvirality(upvotes: post.upvotes, downvotes: post.downvotes, timestamp: post.timestampInSec)
//                    //print("kuchhai: \(temp3)")
//                    
//                    self.posts.sort{ (post1, post2) -> Bool in
//                        let post1Results = self.postvirality(upvotes: post1.upvotes, downvotes: post1.downvotes, timestamp: post1.timestampInSec)
//                        let post2Results = self.postvirality(upvotes: post2.upvotes, downvotes: post2.downvotes, timestamp: post2.timestampInSec)
//                        return post1Results > post2Results
//                    }
//                    //self.posts.sort(by: {$0.upvotes > $1.upvotes})
//                    }
//                }
//            }
            self.tableView.reloadData()

        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell {
            cell.commentBtnAction = {
                self.performSegue(withIdentifier: "gotoImageVC2", sender: indexPath.row)
            }
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) { // this line and one more like this
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
//                self.tableView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(M_PI));
//                cell.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI));
            }
            return cell
        } else {
            return PostCell()
        }

    //return PostCell()//this line
    }
//    
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print("hell")
//        
//        
//    }
//    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("hell2")
//        
//        self.performSegue(withIdentifier: "cellRowTapped", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoImageVC2") {
            // initialize new view controller and cast it as your view controller
            var viewController = segue.destination as! imageVC
            // your new view controller should have property that will store passed value
            let this = posts[sender as! Int]
            print(this.caption)
            viewController.selectedPost = this
        }
        
    }

    
    @IBAction func signoutTapped(_ sender: Any) {
        _ = KeychainWrapper.removeObjectForKey(KEY_UID)
        print("ID removed from Keychain")
        try! Auth.auth().signOut()
        performSegue(withIdentifier: "goToSignIn", sender: nil)
    }
    @IBAction func addimageTapped(_ sender: Any) {
          performSegue(withIdentifier: "goToAddImage", sender: nil)
    }
    
    func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
    
    @IBAction func imageTapped(_ sender: Any) {
//        let myVC = storyboard?.instantiateViewController(withIdentifier: "imageVC2") as! imageVC
//        myVC.stringParsed = "hellooooooo world"
//        navigationController?.pushViewController(myVC, animated: true)
//        performSegue(withIdentifier: "gotoImageVC1", sender: nil)

        
        
    }
//    
//    @IBAction func commentbtnTap(_ sender: Any) {
////        guard let indexPath = self.indexPath else { return }
////        
////        //declare title of button
////        let title = (sender as AnyObject).title(for: UIControlState())
////        
////        //I want get indexPath.row in here!
////        print(indexPath)
//    }
//    
    
    @IBAction func lblUsernameTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToTappedUser", sender: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "gotoImageVC1" {
//            
//            let destSegue = segue.destination as! imageVC
//            print(post.postKey)
//            destSegue.stringParsed = "string"
//            
//        
//            
//        }
//    }
    

    
}
