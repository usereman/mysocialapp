//
//  Comment.swift
//  mysocialapp
//
//  Created by Waqas on 17/07/2017.
//  Copyright © 2017 Abdullah Hafeez. All rights reserved.
//

import Foundation
import Firebase

class Comment{
    private var _text: String!
    private var _imageUrl: String!
    private var _postKey: String!
    private var _postRef: DatabaseReference!
    
    var text: String {
        return _text}
    
    var imageUrl: String {
        return _imageUrl
    }
    
    var postKey: String {
        return _postKey
    }
    
    init(text: String , imageUrl: String , likes: Int) {
        self._text = text
        self._imageUrl = imageUrl
    }
    init(postKey: String, postData : Dictionary<String, AnyObject>) {
        self._postKey = postKey
        
        if let text  = postData["text"] as? String{
            self._text = text
        }
        
        if let imageUrl  = postData["imageUrl"] as? String{
            self._imageUrl = imageUrl
        }
        _postRef = DataService.ds.REF_POSTS.child(_postKey)
    }









}
