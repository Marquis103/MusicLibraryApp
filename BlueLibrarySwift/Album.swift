//
//  Album.swift
//  BlueLibrarySwift
//
//  Created by Marquis Dennis on 12/14/15.
//  Copyright © 2015 Raywenderlich. All rights reserved.
//

import UIKit

class Album: NSObject, NSCoding {
    var title: String!
    var artist: String!
    var genre: String!
    var coverUrl: String!
    var year: String!
    
    init(title: String, artist: String, genre: String, coverUrl: String, year: String) {
        super.init()
        
        self.title = title
        self.artist = artist
        self.genre = genre
        self.coverUrl = coverUrl
        self.year = year
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        
        self.title = decoder.decodeObjectForKey("title") as! String
        self.artist = decoder.decodeObjectForKey("artist") as! String
        self.genre = decoder.decodeObjectForKey("genre") as! String
        self.coverUrl = decoder.decodeObjectForKey("coverUrl") as! String
        self.year = decoder.decodeObjectForKey("year") as! String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(artist, forKey: "artist")
        aCoder.encodeObject(genre, forKey: "genre")
        aCoder.encodeObject(coverUrl, forKey: "coverUrl")
        aCoder.encodeObject(year, forKey: "year")
    }
    
    //string representation of the Album's attributes
    override var description: String {
        return "title: \(title)" +
        "artist: \(artist)" +
        "genre: \(genre)" +
        "coverUrl: \(coverUrl)" +
        "year: \(year)"
    }

}

//a way to implement decorator pattern in ios (extensions)
extension Album {
    func ae_tableRepresentation() -> (titles:[String], values:[String]) {
        return(["Artist", "Album", "Genre", "Year"], [artist, title, genre, year])
    }
}
