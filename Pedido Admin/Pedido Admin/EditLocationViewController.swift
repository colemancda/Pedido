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
    
    weak var delegate: EditLocationViewControllerDelegate?
    
    var locationString: String! {
        
        didSet {
            
            self.configureMapViewWithLocation(locationString)
            
            self.delegate?.editLocationViewController(self, didEditLocationString: locationString)
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
        
        Location.locationWithString(locationString, completion: { (location, error) -> Void in
            
            if error != nil {
                
                self.showErrorAlert(error!.localizedDescription, okHandler: nil, retryHandler: nil)
                
                return
            }
            
            let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
            
            let region  = MKCoordinateRegion(center: location!.coordinate, span: span)
            
            self.mapView.setRegion(region, animated: true)
        })
    }
}

// MARK: - Protocols

protocol EditLocationViewControllerDelegate: class {
    
    func editLocationViewController(viewController: EditLocationViewController, didEditLocationString locationString: String)
}

// MARK: - Supporting Classes

final class Location: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    let coordinate: CLLocationCoordinate2D
    
    let locationString: String
    
    // MARK: - Initialization
    
    class func locationWithString(locationString: String, completion:(location: Location?, error: NSError?) -> Void) {
        
        // perform a search to find a location with the provided string
        
        let request = MKLocalSearchRequest()
        
        request.naturalLanguageQuery = locationString
        
        let search = MKLocalSearch(request: request)
        
        search.startWithCompletionHandler({ (response: MKLocalSearchResponse!, error: NSError!) -> Void in
            
            if error != nil {
                
                completion(location: nil, error: error)
                
                return
            }
            
            let mapItem = response.mapItems.first as MKMapItem
            
            let location = Location(coordinate: mapItem.placemark.coordinate, locationString: locationString)
            
            completion(location: location, error: nil)
        })
    }
    
    private init(coordinate: CLLocationCoordinate2D, locationString: String) {
        
        self.coordinate = coordinate
        self.locationString = locationString
    }
}
