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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "downloadImage:", name: "BLDownloadImageNotification", object: nil)
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
    
    func saveAlbums() {
        persistencyManager.saveAlbums()
    }
    
    func downloadImage(notification: NSNotification) {
        let userInfo = notification.userInfo as! [String: AnyObject]
        let imageView = userInfo["imageView"] as! UIImageView?
        let coverUrl = userInfo["coverUrl"] as! String
        let url = NSURL(string: coverUrl)
        
        if let imageViewUnwrapped = imageView {
            imageViewUnwrapped.image = persistencyManager.getImage((url?.lastPathComponent)!)
            if imageViewUnwrapped.image == nil {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let downloadedImage = self.httpClient.downloadImage(coverUrl as String)
                    
                    dispatch_sync(dispatch_get_main_queue(), { () -> Void in
                        imageViewUnwrapped.image = downloadedImage
                        self.persistencyManager.saveImage(downloadedImage, filename: (url?.lastPathComponent)!)
                    })
                })
            }
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
