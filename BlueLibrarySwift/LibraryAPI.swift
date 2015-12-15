//
//  LibraryAPI.swift
//  BlueLibrarySwift
//
//  Created by Marquis Dennis on 12/14/15.
//  Copyright © 2015 Raywenderlich. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
    
    //implement singleton design pattern
    static let sharedInstance: LibraryAPI = LibraryAPI()
    
    private let persistencyManager: PersistencyManager
    private let httpClient: HTTPClient
    private let isOnline:Bool
    
    override init() {
        persistencyManager = PersistencyManager()
        httpClient = HTTPClient()
        isOnline = false
        
        super.init()
    }
    
    //:MARK - LibraryAPI Facade
    func getAlbums() -> [Album] {
        return persistencyManager.getAlbums()
    }
    
    func addAlbum(album: Album, index: Int) {
        persistencyManager.addAlbum(album, index: index)
        
        if isOnline {
            httpClient.postRequest("/api/addAlbum", body: album.description)
        }
    }
    
    func deleteAlbum(index: Int) {
        persistencyManager.deleteAlbumAtIndex(index)
        
        if isOnline {
            httpClient.postRequest("/api/deleteAlbum", body: ("\(index)"))
        }
    }
}
