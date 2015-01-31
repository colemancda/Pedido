//
//  EditLocationViewController.swift
//  PedidoAdmin
//
//  Created by Alsey Coleman Miller on 1/17/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class EditLocationViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    var locationString: String! {
        
        didSet {
            
            self.configureMapViewWithLocation(locationString)
        }
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureMapViewWithLocation(self.locationString)
    }
    
    // MARK: - Methods
    
    
    
    // MARK: - Private Methods
    
    private func configureMapViewWithLocation(location: String) {
        
        // remove previous annotation
        
        
        
        // create annotation based on location
        
        
    }
}

// MARK: - Supporting Classes

class Location: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    let coordinate: CLLocationCoordinate2D
    
    let stringValue: String
    
    // MARK: - Initialization
    
    class func locationWithString(string: String, completion:(location: Location?, error: NSError?) -> Void) {
        
        // perform a search to find a location with the provided string
        
    }
    
    private init(coordinate: CLLocationCoordinate2D, stringValue: String) {
        
        self.coordinate = coordinate
        self.stringValue = stringValue
    }
    
}
