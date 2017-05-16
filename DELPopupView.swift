//
//  DELPopupView.swift
//  Modal Popover
//
//  Created by Daniel-Ernest Luff on 16/05/17
//  Copyright (c) 2017 Toutright. All rights reserved.
//

import DELPopupView
import QuartzCore
private var HANDLE_VIEW_ANIMATION_DUTARION: float = 0.2
//static float const ROOT_VIEW_SCALE_FACTOR = 0.9;

class DELPopupView {
    
    var blackTransparentView: UIView?
    var blackView: UIView?
    var renderImageView: UIImageView?
    
    init() {
        return DELPopupView.popupView()
    }
    
    class func popupView() -> DELPopupView {
        var keyWindow: UIWindow = UIApplication.sharedApplication().keyWindow()
        var rootView: UIView = keyWindow.rootViewController.view
        var rect: CGRect = CGRectMake(0, 0, rootView.frame.size.width, rootView.frame.size.height)
        if rootView.transform.b != 0 && rootView.transform.c != 0 {
            rect = CGRectMake(0, 0, rootView.frame.size.height, rootView.frame.size.width)
        }
        var v: DELPopupView = DELPopupView(frame: rect)
        v.handleView = UIView(frame: v.frame)
        v.handleView.backgroundColor = UIColor.clearColor()
        v.handleView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth
        v.handleView.clipsToBounds = true
        v.blackTransparentView = UIView(frame: v.frame)
        v.blackTransparentView.backgroundColor = UIColor.blackColor()
        v.blackTransparentView.alpha = 0.0
        v.renderImageView = UIImageView(frame: v.frame)
        v.renderImageView.contentMode = UIViewContentModeScaleToFill
        v.addSubview(v.renderImageView)
        v.addSubview(v.blackTransparentView)
        v.addSubview(v.handleView)
        return v
    }
    
    func show() {
        var keyWindow: UIWindow = UIApplication.sharedApplication().keyWindow()
        var ctrl: UIViewController = keyWindow.rootViewController
        while ctrl.presentedViewController {
            ctrl = ctrl.presentedViewController
        }
        var rootView: UIView = ctrl.view
        var rect: CGRect = CGRectMake(0, 0, rootView.frame.size.width, rootView.frame.size.height)
        if rootView.transform.b != 0 && rootView.transform.c != 0 {
            rect = CGRectMake(0, 0, rootView.frame.size.height, rootView.frame.size.width)
        }
        self.frame = rect
        //Performing selector after delay just for let UIButton change state from Highlighted before render View
        self.performSelector("showInNextRunLoop", withObject: nil, afterDelay: 0.1)
    }
    
    func showInNextRunLoop() {
        var keyWindow: UIWindow = UIApplication.sharedApplication().keyWindow()
        var ctrl: UIViewController = keyWindow.rootViewController
        while ctrl.presentedViewController {
            ctrl = ctrl.presentedViewController
        }
        var rootView: UIView = ctrl.view
        var rootViewRenderImage: UIImage = self.imageWithView(rootView)
        self.renderImageView.image = rootViewRenderImage
        self.blackTransparentView.alpha = 0.0
        rootView.addSubview(self)
        self.handleView.center = CGPointMake(self.frame.size.width/2.0, self.handleView.frame.size.height*1.5)
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptionCurveEaseInOut, animations: {	self.blackTransparentView.alpha = 0.4
            
        }, completion: { (finished: Bool) in
            
        })
        UIView.animateWithDuration(HANDLE_VIEW_ANIMATION_DUTARION, delay: 0.0, options: UIViewAnimationOptionCurveEaseInOut, animations: {	self.handleView.center = self.center
            
        }, completion: { (finished: Bool) in
            
        })
    }
    
    func hideAnimated(animated: Bool) {
        if !animated {
            self.blackTransparentView.alpha = 0.0
            self.renderImageView.frame = self.frame
            self.removeFromSuperview()
            return
        }
        UIView.animateWithDuration(HANDLE_VIEW_ANIMATION_DUTARION, delay: 0, options: UIViewAnimationOptionCurveEaseInOut, animations: {	self.handleView.center = CGPointMake(self.frame.size.width/2.0, self.handleView.frame.size.height*1.5)
            
        }, completion: { (finished: Bool) in
            
        })
        UIView.animateWithDuration(0.3, delay: 0.1, options: UIViewAnimationOptionCurveEaseInOut, animations: {	self.blackTransparentView.alpha = 0.0
            self.renderImageView.frame = self.frame
            
        }, completion: { (finished: Bool) in
            self.removeFromSuperview()
            
        })
    }
    
    func willRotateToOrientation(toInterfaceOrientation: UIInterfaceOrientation, withDuration duration: NSTimeInterval) {
        if self.superview {
            self.removeFromSuperview()
            self.renderImageView.frame = self.frame
            self.performSelector("showAgain", withObject: nil, afterDelay: duration)
        }
    }
    
    func showAgain() {
        self.show()
    }
    
    func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.renderImageView.frame.size, view.opaque, UIScreen.mainScreen().scale())
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        var img: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    
    func dealloc() {
        UIDevice.currentDevice().endGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

