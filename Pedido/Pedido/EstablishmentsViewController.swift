//
//  EstablishmentsViewController.swift
//  Pedido
//
//  Created by Alsey Coleman Miller on 12/7/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import NetworkObjects
import CorePedido
import CorePedidoClient

class EstablishmentsViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.locationManager.requestWhenInUseAuthorization()
        
    }
    
    
    
}