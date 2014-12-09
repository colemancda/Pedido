//
//  Error.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/8/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /** Presents an error alert controller with the specified completion handlers.  */
    func showErrorAlert(localizedText: String, okHandler: (() -> Void)? = nil, retryHandler: (()-> Void)? = nil) {
        
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"),
            message: localizedText,
            preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            
            alert.dismissViewControllerAnimated(true, completion: okHandler)
        }))
        
        // optionally add retry button
        
        if retryHandler != nil {
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("Retry", comment: "Retry"), style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                alert.dismissViewControllerAnimated(true, completion: { () -> Void in
                    
                    retryHandler!()
                })
            }))
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
