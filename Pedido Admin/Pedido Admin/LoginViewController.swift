//
//  LoginViewController.swift
//  Pedido Admin
//
//  Created by Alsey Coleman Miller on 12/7/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import NetworkObjects
import CorePedido
import CorePedidoClient

class LoginViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var serverURLTextField: UITextField!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func login(sender: UIButton) {
        
        // disable button and start authentication process
        
        sender.enabled = false
        
        let serverURL = NSURL(string: self.serverURLTextField.text)?.standardizedURL
        
        if serverURL == nil {
            
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"),
                message: NSLocalizedString("Invalid server URL", comment: "Invalid server URL"),
                preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            sender.enabled = true
            
            return
        }
        
        // set new server URL
        CorePedidoClient.Store.sharedStore.serverURL = serverURL!
        
        // login request
        
        CorePedidoClient.Store.sharedStore.loginWithUsername(usernameTextField.text, password: passwordTextField.text, completionBlock: { (error, token) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                // enable login button
                
                sender.enabled = true
                
                // show error
                if error != nil {
                    
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"),
                        message: error!.localizedDescription,
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK"), style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
                        
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    return
                }
                
                // present tab bar controller
                
                self.performSegueWithIdentifier(MainStoryboardSegueIdentifier.AuthenticationSegue.rawValue, sender: self)
            })
        })
    }
    
}

