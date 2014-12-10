//
//  File.swift
//  CorePedidoServer
//
//  Created by Alsey Coleman Miller on 12/9/14.
//  Copyright (c) 2014 ColemanCDA. All rights reserved.
//

import Foundation

// MARK: - Constants

public let ServerApplicationSupportFolderURL: NSURL = NSFileManager.defaultManager().URLForDirectory(.ApplicationSupportDirectory, inDomain: NSSearchPathDomainMask.LocalDomainMask, appropriateForURL: nil, create: false, error: nil)!.URLByAppendingPathComponent("PedidoServer")

public let ServerSQLiteFileURL = ServerApplicationSupportFolderURL.URLByAppendingPathComponent("data.sqlite")

public let ServerLastResourceIDByEntityNameFileURL = ServerApplicationSupportFolderURL.URLByAppendingPathComponent("lastResourceIDByEntityName.plist")

public let ServerSettingsFileURL = ServerApplicationSupportFolderURL.URLByAppendingPathComponent("serverSettings.plist")

// MARK: - Enumerations

public enum ServerSetting: String {
    
    case SessionTokenLength = "SessionTokenLength"
    case SessionExpiryTimeInterval = "SessionExpiryTimeInterval"
    case SessionTokenCacheLimit = "SessionTokenCacheLimit"
}

// MARK: - Functions

/** Load the saved Server setting value from disk. */
public func LoadServerSetting(serverSetting: ServerSetting) -> AnyObject? {
    
    // try to load archived settings
    let archivedServerSettings = NSDictionary(contentsOfURL: ServerSettingsFileURL) as? [String: AnyObject]
    
    return archivedServerSettings?[serverSetting.rawValue]
}

/** Saves the specified setting to disk. */
public func SaveServerSetting(serverSetting: ServerSetting, value: AnyObject) -> Bool {
    
    // try to load archived settings
    var currentSettings = NSDictionary(contentsOfURL: ServerSettingsFileURL) as? [String: AnyObject]
    
    // new settings
    if currentSettings == nil {
        
        currentSettings = [String: AnyObject]()
    }
    
    // set new setting value
    currentSettings![serverSetting.rawValue] = value
    
    // try to save
    return (currentSettings as NSDictionary).writeToURL(ServerSettingsFileURL, atomically: true)
}


