//
//  Album.swift
//  Sarah
//
//  Created by Sarah Zerafa Saydon on 27/11/2018.
//  Copyright © 2018 Sarah Zerafa Saydon. All rights reserved.
//

import UIKit

class Album: NSObject {

    var title:String!
    var artist:String!
    var genre:String!
    var artworkURL:String!
    var artworkURLLarge:String!
    var trackId:String!
    var selected:Bool!
    
    init(title:String,artist:String,genre:String,artworkURL:String,trackId:String,artworkURLLarge:String,selected:Bool)
    {
        super.init()
        self.title = title
        self.artist = artist
        self.genre = genre
        self.artworkURL = artworkURL
         self.artworkURLLarge = artworkURLLarge
        self.trackId = trackId
        self.selected = selected
    }
}
