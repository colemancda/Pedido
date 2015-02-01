//
//  NetworkActivityIndicatorManager.swift
//  PedidoAdmin
//
//  Created by Alsey Coleman Miller on 1/30/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit

final public class NetworkActivityIndicatorManager {
    
    // MARK: - Properties
    
    public let URLSession: NSURLSession
    
    public var managingNetworkActivityIndicator: Bool = false {
        
        didSet {
            
            if managingNetworkActivityIndicator == true {
                
                if self.timer == nil {
                    
                    self.timer = NSTimer(timeInterval: self.updateInterval, target: self, selector: "updateNetworkActivityIndicator", userInfo: nil, repeats: true)
                    
                    NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
                }
                
                self.timer!.fire()
            }
            else {
                
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }
    
    public let updateInterval: NSTimeInterval
    
    /** The minimum amount of time the activity indicator must be visible. Prevents blinks. */
    public var minimumNetworkActivityIndicatorVisiblityInterval: NSTimeInterval
    
    // MARK: - Private Properties
    
    private var timer: NSTimer?
    
    private var lastNetworkActivityIndicatorVisibleState: Bool = false
    
    private var lastNetworkActivityIndicatorVisibleStateTransitionToTrue: NSDate?
    
    // MARK: - Initialization
    
    class var sharedManager: NetworkActivityIndicatorManager {
        
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : NetworkActivityIndicatorManager? = nil
        }
        
        dispatch_once(&Static.onceToken) {
            Static.instance = NetworkActivityIndicatorManager()
        }
        
        return Static.instance!
    }
    
    public init(URLSession: NSURLSession = NSURLSession.sharedSession(), updateInterval: NSTimeInterval = 0.001, minimumNetworkActivityIndicatorVisiblityInterval: NSTimeInterval = 1) {
        
        self.URLSession = URLSession
        self.updateInterval = updateInterval
        self.minimumNetworkActivityIndicatorVisiblityInterval = minimumNetworkActivityIndicatorVisiblityInterval
    }
    
    // MARK: - Private Methods
    
    @objc private func updateNetworkActivityIndicator() {
        
        if self.lastNetworkActivityIndicatorVisibleStateTransitionToTrue != nil {
            
            let timeInterval = NSDate().timeIntervalSinceDate(lastNetworkActivityIndicatorVisibleStateTransitionToTrue!)
            
            if timeInterval < minimumNetworkActivityIndicatorVisiblityInterval {
                
                return
            }
            else {
                
                lastNetworkActivityIndicatorVisibleStateTransitionToTrue = nil
            }
        }
        
        self.URLSession.getTasksWithCompletionHandler { (dataTasks: [AnyObject]!, uploadTasks: [AnyObject]!, downloadTasks: [AnyObject]!) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                let networkActivityIndicatorVisible = Bool(dataTasks.count)
                
                if self.lastNetworkActivityIndicatorVisibleState == false && networkActivityIndicatorVisible == true {
                    
                    self.lastNetworkActivityIndicatorVisibleStateTransitionToTrue = NSDate()
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = networkActivityIndicatorVisible
                
                self.lastNetworkActivityIndicatorVisibleState = networkActivityIndicatorVisible
            })
        }
    }
}