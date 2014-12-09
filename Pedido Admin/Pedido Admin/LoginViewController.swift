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
    
    @IBAction func login(sender: AnyObject) {
        
        // disable button and start authentication process
        
        self.loginButton.enabled = false
        
        let serverURL = NSURL(string: self.serverURLTextField.text)?.standardizedURL
        
        if serverURL == nil {
            
            self.showErrorAlert(NSLocalizedString("Invalid server URL", comment: "Invalid server URL"))
            
            self.loginButton.enabled = true
            
            return
        }
        
        // set new server URL
        CorePedidoClient.Store.sharedStore.serverURL = serverURL!
        
        // login request
        
        CorePedidoClient.Store.sharedStore.loginWithUsername(usernameTextField.text, password: passwordTextField.text, completionBlock: { (error, token) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                // show error
                if error != nil {
                    
                    self.showErrorAlert(error!.localizedDescription, okHandler: { () -> Void in
                        
                        // enable login button
                        self.loginButton.enabled = true
                        
                    }, retryHandler: { () -> Void in
                        
                         self.login(self)
                    })
                    
                    return
                }
                
                // enable login button
                self.loginButton.enabled = true
                
                // present tab bar controller
                self.performSegueWithIdentifier(MainStoryboardSegueIdentifier.Authentication.rawValue, sender: self)
            })
        })
    }
    
}

