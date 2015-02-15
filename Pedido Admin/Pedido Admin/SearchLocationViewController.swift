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
    
    private var searchResults: [MKMapItem]?
    
    private var currentSearch: (search: MKLocalSearch, searchText: String)?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func cancel(sender: AnyObject) {
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
        
        let (search, searchText) = self.currentSearch!
        
        // tell delegate
        self.delegate?.locationSearchViewController(self, didChooseSearchResult: searchResult, forSearchText: searchText)
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
        
        if let (oldSearch, oldSearchText) = self.currentSearch {
            
            oldSearch.cancel()
        }
        
        // create search request
        
        let searchRequest = MKLocalSearchRequest()
        
        if self.searchRegion != nil {
            
            searchRequest.region = self.searchRegion!
        }
        
        searchRequest.naturalLanguageQuery = searchText
        
        // execute request
        
        let search = MKLocalSearch(request: searchRequest)
        
        self.currentSearch = (search, searchText)
        
        search.startWithCompletionHandler { (response: MKLocalSearchResponse!, error: NSError!) -> Void in
            
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
    
    func locationSearchViewController(viewController: SearchLocationViewController, didChooseSearchResult searchResult: MKMapItem, forSearchText searchText: String)
}

// MARK: - Private Enumerations

private enum CellIdentifier: String {
    
    case LocationSearchResultCell = "LocationSearchResultCell"
}
