//
//  AlbumView.swift
//  BlueLibrarySwift
//
//  Created by Marquis Dennis on 12/14/15.
//  Copyright © 2015 Raywenderlich. All rights reserved.
//

import UIKit

class AlbumView: UIView {

    private var coverImage: UIImageView!
    private var indicator: UIActivityIndicatorView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    init(frame: CGRect, albumCover: String) {
        super.init(frame: frame)
        commonInit()
        
        NSNotificationCenter.defaultCenter().postNotificationName("BLDownloadImageNotification", object: self, userInfo: ["imageView":coverImage, "coverUrl":albumCover])
        coverImage.addObserver(self, forKeyPath: "image", options: .Initial, context: nil)
    }
    
    func commonInit() {
        backgroundColor = UIColor.blackColor()
        coverImage = UIImageView(frame: CGRect(x: 5, y: 5, width: frame.size.width - 10, height: frame.size.height - 10))
        addSubview(coverImage)
        indicator = UIActivityIndicatorView()
        indicator.center = center
        indicator.activityIndicatorViewStyle = .WhiteLarge
        indicator.startAnimating()
        addSubview(indicator)
    }
    
    func highlightAlbum(didHighlightView: Bool) {
        if didHighlightView {
            backgroundColor = UIColor.whiteColor()
        } else {
            backgroundColor = UIColor.blackColor()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "image" {
            indicator.stopAnimating()
        }
    }
    
    deinit {
        coverImage.removeObserver(self, forKeyPath: "image")
    }

}
