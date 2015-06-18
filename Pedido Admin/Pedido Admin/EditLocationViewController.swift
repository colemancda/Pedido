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

class EditLocationViewController: UIViewController, LocationSearchViewControllerDelegate {
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    weak var delegate: EditLocationViewControllerDelegate?
    
    /** The annotation to show in the map view. */
    var location: Location? {
        
        willSet {
            
            // remove old
            if location != nil {
                
                self.mapView.removeAnnotation(location)
            }
        }
        
        didSet {
            
            if location != nil {
                
                // create annotation
                self.mapView.addAnnotation(location)
                
                // set region
                let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                
                let region  = MKCoordinateRegion(center: location!.coordinate, span: span)
                
                self.mapView.setRegion(region, animated: true)
                
                self.mapView.selectAnnotation(location, animated: true)
            }
        }
    }
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set location again to refresh map view
        if let location = self.location {
            
            self.location = location
        }
    }
    
    // MARK: - Methods
    
    func configureMapViewWithLocationString(locationString: String) {
        
        // create annotation based on location
        
        Location.locationWithString(locationString, completion: { (location, error) -> Void in
            
            if error != nil {
                
                self.showErrorAlert(error!.localizedDescription, retryHandler: {
                    
                    self.configureMapViewWithLocationString(locationString)
                })
                
                return
            }
            
            // set location annotation (will configure map view)
            self.location = location
        })
    }
    
    // MARK: - LocationSearchViewControllerDelegate
    
    func locationSearchViewController(viewController: SearchLocationViewController, didChooseSearchResult searchResult: MKMapItem, forSearchText searchText: String) {
        
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            
            // create location
            let location = Location(coordinate: searchResult.placemark.coordinate, locationString: searchText)
            
            // set location
            self.location = location
            
            // tell delegate
            self.delegate?.editLocationViewController(self, didEditLocation: self.location!)
        })
    }
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        switch MainStoryboardSegueIdentifier(rawValue: segue.identifier!)! {
            
        case .SearchLocation:
            
            let searchLocationVC = (segue.destinationViewController as! UINavigationController).topViewController as! SearchLocationViewController
            
            searchLocationVC.searchRegion = self.mapView.region
            
            searchLocationVC.delegate = self
            
        default:
            return
        }
    }
}

// MARK: - Protocols

protocol EditLocationViewControllerDelegate: class {
    
    func editLocationViewController(viewController: EditLocationViewController, didEditLocation location: Location)
}

// MARK: - Supporting Classes

final class Location: NSObject, MKAnnotation {
    
    // MARK: - Properties
    
    let locationString: String
    
    // MARK: MKAnnotation
    
    let coordinate: CLLocationCoordinate2D
    
    var title: String {
        
        return locationString
    }
    
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
            
            let mapItem = response.mapItems.first as! MKMapItem
            
            let location = Location(coordinate: mapItem.placemark.coordinate, locationString: locationString)
            
            completion(location: location, error: nil)
        })
    }
    
    init(coordinate: CLLocationCoordinate2D, locationString: String) {
        
        self.coordinate = coordinate
        self.locationString = locationString
    }
}
