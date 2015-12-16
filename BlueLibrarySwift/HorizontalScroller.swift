//
//  HorizontalScroller.swift
//  BlueLibrarySwift
//
//  Created by Marquis Dennis on 12/15/15.
//  Copyright © 2015 Raywenderlich. All rights reserved.
//

import UIKit

@objc protocol HorizontalScrollerDeletgate {

    //ask the delegate how many views he wants to present inside the horizontal scroller
    func numberOfViewsForHorizontalScoller(scroller: HorizontalScroller) -> Int
    
    //ask the delegate to return the view that should appear at <index>
    func horizontalScrollerViewAtIndex(scroller:HorizontalScroller, index: Int) -> UIView
    
    //inform the delegate that the view at <index> has been clicked
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index: Int)
    
    //ask the delegate for teh index of the initial view to display.  this method is optional
    //and defaults to 0 if it's not implemented by the delegate
    optional func initialViewIndex(scroller: HorizontalScroller) -> Int
}

class HorizontalScroller: UIView {
    
    //deletegate property must be weak to prevent a retain cycle
    //delegate is optional just in case the implementer doesn't provide a delegate
    weak var delegate: HorizontalScrollerDeletgate?
    
    private let VIEW_PADDING = 10
    private let VIEW_DIMENSIONS = 100
    private let VIEWS_OFFSET = 100
    
    private var scroller:UIScrollView
    
    var viewArray = [UIView]()
    
    override init(frame: CGRect) {
        scroller = UIScrollView()
        super.init(frame: frame)
        initializeScrollView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        scroller = UIScrollView()
        super.init(coder: aDecoder)
        initializeScrollView()
    }
    
    func initializeScrollView() {
        scroller.delegate = self
        
        addSubview(scroller)
        
        scroller.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        self.addConstraint(NSLayoutConstraint(item: scroller, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("scrollerTapped:"))
        scroller.addGestureRecognizer(tapRecognizer)
    }
    
    func viewAtIndex(index:Int) -> UIView {
        return viewArray[index]
    }
    
    func centerCurrentView() {
        var xFinal = Int(scroller.contentOffset.x) + (VIEWS_OFFSET/2) + VIEW_PADDING
        let viewIndex = xFinal / (VIEW_DIMENSIONS + (2 * VIEW_PADDING))
        xFinal = viewIndex * (VIEW_DIMENSIONS + (2 * VIEW_PADDING))
        scroller.setContentOffset(CGPoint(x: xFinal, y:0), animated: true)
        if let delegate = delegate {
            delegate.horizontalScrollerClickedViewAtIndex(self, index: Int(viewIndex))
        }
    }
    
    //method is called when the view is added to another view as a subview
    override func didMoveToSuperview() {
        reload()
    }
    
    func reload() {
        //check if there is a delegate, if not there is nothing to load
        if let delegate = delegate {
            //will keep adding new album views on reload, need to reset
            viewArray = []
            let views:NSArray = scroller.subviews
            for view in views {
                view.removeFromSuperview()
            }
            var xValue = VIEWS_OFFSET
            for index in 0..<delegate.numberOfViewsForHorizontalScoller(self) {
                xValue += VIEW_PADDING
                let view = delegate.horizontalScrollerViewAtIndex(self, index: index)
                view.frame = CGRectMake(CGFloat(xValue), CGFloat(VIEW_PADDING), CGFloat(VIEW_DIMENSIONS), CGFloat(VIEW_DIMENSIONS))
                scroller.addSubview(view)
                xValue += VIEW_DIMENSIONS + VIEW_PADDING
                viewArray.append(view)
            }
            
            scroller.contentSize = CGSizeMake(CGFloat(xValue + VIEWS_OFFSET), frame.size.height)
            
            if let initialView = delegate.initialViewIndex?(self) {
                scroller.setContentOffset(CGPoint(x: CGFloat(initialView) * CGFloat((VIEW_DIMENSIONS + (2 * VIEW_PADDING))), y: 0), animated: true)
            }
        }
    }
    
    func scrollerTapped(gesture: UITapGestureRecognizer) {
        let location = gesture.locationInView(gesture.view)
        
        if let delegate = delegate {
            for index in 0..<delegate.numberOfViewsForHorizontalScoller(self) {
                let view = scroller.subviews[index] 
                
                if CGRectContainsPoint(view.frame, location) {
                    delegate.horizontalScrollerClickedViewAtIndex(self, index: index)
                    scroller.setContentOffset(                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                CGPoint(x: view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2, y: 0), animated: true)
                    break
                }
            }
        }
    }
}

extension HorizontalScroller : UIScrollViewDelegate {
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentView()
        }
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        centerCurrentView()
    }
}