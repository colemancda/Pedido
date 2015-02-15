//
//  SearchLocationViewController.swift
//  PedidoAdmin
//
//  Created by Alsey Coleman Miller on 2/14/15.
//  Copyright (c) 2015 ColemanCDA. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class SearchLocationViewController: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Properties
    
    /** The region to provide as a hint for performing searches. */
    var searchRegion: MKCoordinateRegion?
    
    weak var delegate: LocationSearchViewControllerDelegate?
    
    // MARK: - Private Properties
    
    var searchResults: [MKMapItem]?
    
    var currentSearch: MKLocalSearch?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Actions
    
    func cancel(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.searchResults?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // dequeue cell
        let cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier.LocationSearchResultCell.rawValue) as UITableViewCell
        
        // configure cell
        self.configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // get model object
        let searchResult = self.searchResults![indexPath.row]
        
        // tell delegate
        self.delegate?.locationSearchViewController(self, didChooseSearchResult: searchResult)
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            
            self.searchResults = nil
            
            return
        }
        
        if searchBar.text == "" {
            
            self.searchResults = nil
            
            return
        }
        
        self.performSearch(searchBar.text)
    }
    
    // MARK: - Private Methods
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: NSIndexPath) {
        
        // get model object
        let searchResult = self.searchResults![indexPath.row]
        
        cell.textLabel!.text = searchResult.name
    }
    
    private func performSearch(searchText: String) {
        
        // cancel old request
        
        self.currentSearch?.cancel()
        
        // create search request
        
        let searchRequest = MKLocalSearchRequest()
        
        if self.searchRegion != nil {
            
            searchRequest.region = self.searchRegion!
        }
        
        searchRequest.naturalLanguageQuery = searchText
        
        // execute request
        
        self.currentSearch = MKLocalSearch(request: searchRequest)
        
        self.currentSearch!.startWithCompletionHandler { (response: MKLocalSearchResponse!, error: NSError!) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                
                if error != nil {
                    
                    // if not found, then dont forward error to UI
                    if error.code == Int(MKErrorCode.PlacemarkNotFound.rawValue) {
                        
                        self.searchResults = nil
                        
                        self.tableView.reloadData()
                        
                        return
                    }
                    
                    self.showErrorAlert(error.localizedDescription, retryHandler: {
                        
                        self.performSearch(searchText)
                    })
                    
                    return
                }
                
                // reload table view with results
                
                self.searchResults = response.mapItems as [MKMapItem]!
                
                self.tableView.reloadData()
            })
        }
    }
}

// MARK: - Protocols

protocol LocationSearchViewControllerDelegate: class {
    
    func locationSearchViewController(viewController: SearchLocationViewController, didChooseSearchResult searchResult: MKMapItem)
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case LocationSearchResultCell = "LocationSearchResultCell"
}
