//
//  Post.swift
//  mysocialapp
//
//  Created by Abdullah Hafeez
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import Foundation
import Firebase

class Post{
    private var _caption: String!
    private var _imageUrl: String!
    private var _upvotes: Int!
    private var _downvotes: Int!
    private var _postKey: String!
    private var _username: String!
    private var _timeStamp: String!
    private var _timestampInSec: Int!
    private var _postRef: DatabaseReference!
    
    var caption: String {
    return _caption}
    
    var username: String {
        return _username}
    
    var imageUrl: String {
        return _imageUrl}
    
    var upvotes: Int {
        return _upvotes}
    
    var downvotes: Int {
        return _downvotes}
    
    var postKey: String {
        return _postKey
    }
    
    var timeStamp: String {
        return _timeStamp
    }
    var timestampInSec: Int {
        return _timestampInSec
    }
    init(caption: String , imageUrl: String , likes: Int) {
        self._caption = caption
        self._username = username
        self._imageUrl = imageUrl
        self._upvotes = upvotes
        self._downvotes = downvotes
        self._timeStamp = timeStamp
        self._timestampInSec = timestampInSec
    }
    
    init(postKey: String, postData : Dictionary<String, Any>) {
        self._postKey = postKey
        
        if let caption  = postData["caption"] as? String{
        self._caption = caption
        }
        
        if let username  = postData["username"] as? String{
            self._username = username
        }
        
        if let imageUrl  = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        
        if let upvotes  = postData["upvotes"] as? Int{
            self._upvotes = upvotes
        }
        
        if let downvotes  = postData["downvotes"] as? Int{
            self._downvotes = downvotes
        }
        
        if let timeStamp = postData["timeStamp"] as? String{
            self._timeStamp = timeStamp
        }
        
        if let timestampInSec = postData["timestampInSec"] as? Int{
            self._timestampInSec = timestampInSec
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }
    
    func adjustvotes(addvote: Bool){
        if addvote{
            _upvotes = _upvotes + 1
        } else {
            _upvotes = _upvotes - 1
        }
        _postRef.child("upvotes").setValue(_upvotes)
    }
    func adjustvotes2(addvote: Bool){
        if addvote{
            _downvotes = _downvotes + 1
        } else {
            _downvotes = _downvotes - 1
        }
        _postRef.child("downvotes").setValue(_downvotes)
    }

}
