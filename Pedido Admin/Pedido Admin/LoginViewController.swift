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
    
    // MARK: - Properties
    
    var store: CorePedidoClient.Store?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func login(sender: UIButton) {
        
        // disable button and start authentication process
        
        sender.enabled = false
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: CorePedidoManagedObjectModel)
        
        // add persistent store
        
        var error: NSError?
        
        psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil, error: &error)
        
        assert(error == nil, "Could add persistent store. (\(error!.localizedDescription))")
        
        let serverURL = NSURL(string: self.serverURLTextField.text)
        
        if serverURL == nil {
            
            let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"),
                message: NSLocalizedString("Invalid server URL", comment: "Invalid server URL"),
                preferredStyle: UIAlertControllerStyle.Alert)
            
            self.presentViewController(alert, animated: true, completion: nil)
            
            sender.enabled = true
            
            return
        }
        
        self.store = CorePedidoClient.Store(persistentStoreCoordinator: psc,
            managedObjectContextConcurrencyType: .MainQueueConcurrencyType,
            serverURL: serverURL!,
            prettyPrintJSON: true,
            delegate: AuthenticationManager())
        
        // login request
        
        self.store!.loginWithUsername(usernameTextField.text, password: passwordTextField.text, completionBlock: { (error, token) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                // enable login button
                
                sender.enabled = true
                
                // show error
                if error != nil {
                    
                    let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Error"),
                        message: error!.localizedDescription,
                        preferredStyle: UIAlertControllerStyle.Alert)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    return
                }
                
                // present tab bar controller
                
                self.performSegueWithIdentifier(MainStoryboardSegueIdentifier.AuthenticationSegue.rawValue, sender: self)
            })
        })
    }
    
}

