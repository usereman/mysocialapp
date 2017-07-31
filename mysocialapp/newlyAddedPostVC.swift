//
//  newlyAddedPostVC.swift
//  mysocialapp
//
//  Created by Abdullah Hafeez on 7/6/17.
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class newlyAddedPostVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    static var imageCache: NSCache<NSString, UIImage> = NSCache()
    var post: Post!
    var valueToPass:String!
    // static var imageCache: Cache<NSString, UIImage> = Cache() this line
    
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
        
        
        DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    print("SNAP: \(snap)")
                    if let postDict = snap.value as? Dictionary< String, AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key , postData: postDict)
                        self.posts.append(post)
                        self.posts.reverse()
                    }
                }
            }
            self.tableView.reloadData()
            
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
                self.performSegue(withIdentifier: "gotoImageVC", sender: indexPath.row)
            }
            
            if let img = FeedVC.imageCache.object(forKey: post.imageUrl as NSString) { // this line and one more like this
                cell.configureCell(post: post, img: img)
            } else {
                cell.configureCell(post: post)
            }
            return cell
        } else {
            return PostCell()
        }
        
        //return PostCell()//this line
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        let DvC = Storyboard.instantiateViewController(withIdentifier: "imageVC") as! imageVC
        
        
        //        DvC.getImage = FeedVC.imageCache.object(forKey: post.imageUrl as NSString)!
        //        DvC.getCaption = post.caption
        
       // let indexPath = tableView.indexPathForSelectedRow!
        //  let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
      //  valueToPass = post.caption
        //performSegue(withIdentifier: "gotoImageVC", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "gotoImageVC") {
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
//    @IBAction func addimageTapped(_ sender: Any) {
//        performSegue(withIdentifier: "goToAddImage", sender: nil)
//    }
    
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
        performSegue(withIdentifier: "gotoImageVC", sender: nil)
    }
    
    
    @IBAction func lblUsernameTapped(_ sender: Any) {
        performSegue(withIdentifier: "goToTappedUser", sender: nil)
    }
    
}

