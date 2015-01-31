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
    
    public var managingNetworkActivityIndicator: Bool! {
        
        didSet {
            
            if managingNetworkActivityIndicator == true {
                
                self.updateNetworkActivityIndicator()
            }
            else {
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        }
    }
    
    /** The minimum amount of time the activity indicator must be visible. Prevents blinks. */
    public var minimumNetworkActivityIndicatorVisiblityInterval: NSTimeInterval
    
    // MARK: - Private Properties
    
    private var lastNetworkActivityIndicatorVisibleState: Bool = false
    
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
    
    public init(URLSession: NSURLSession = NSURLSession.sharedSession(), minimumNetworkActivityIndicatorVisiblityInterval: NSTimeInterval = 2) {
        
        self.URLSession = URLSession
        self.minimumNetworkActivityIndicatorVisiblityInterval = minimumNetworkActivityIndicatorVisiblityInterval
        self.managingNetworkActivityIndicator = false
    }
    
    // MARK: - Private Methods
    
    @objc private func updateNetworkActivityIndicator() {
        
        self.URLSession.getTasksWithCompletionHandler { (dataTasks: [AnyObject]!, uploadTasks: [AnyObject]!, downloadTasks: [AnyObject]!) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                if self.managingNetworkActivityIndicator == false {
                    
                    return
                }
                
                let networkActivityIndicatorVisible = Bool(dataTasks.count)
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = networkActivityIndicatorVisible
                
                // delay updating network activity indicator visiblity if it is showing and it was previously not visible
                if networkActivityIndicatorVisible == true && self.lastNetworkActivityIndicatorVisibleState == false {
                    
                    let dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(self.minimumNetworkActivityIndicatorVisiblityInterval * Double(NSEC_PER_SEC)))
                    
                    dispatch_after(dispatchTime, dispatch_get_main_queue(), { () -> Void in
                        
                        self.updateNetworkActivityIndicator()
                    })
                }
                    
                // immediately try to get new network activity indicator status
                else {
                    
                    self.updateNetworkActivityIndicator()
                }
                
                // set last state
                self.lastNetworkActivityIndicatorVisibleState = networkActivityIndicatorVisible
            })
        }
    }
}