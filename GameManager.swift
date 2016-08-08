//
//  GameManager.swift
//  GameManager
//
//  Created by Martin Walsh on 26/07/2016.
//
//  Make sure to look in AppDelegate.swift

import Foundation

/* Define properties to be stored in NSUserDefaults */
extension DefaultsKeys {
    static let level = DefaultsKey<Int>("level")
}

class GameManager {
    
    /* Swift Singleton */
    static let sharedInstance = GameManager()
    
    /* Properties */
    var level = 0
    var levelsCompleted = 0
    
    init() {
        /* Load stored data by default */
        print("GameManager: Initialised")
        loadData()
    }
    
    func saveData() {
        /* Store specified property data */
        print("GameManager: saveData")
        
        Defaults[.level] = level
    }
    
    func loadData() {
        /* Populate specified properties with stored data */
        print("GameManager: loadData")
        
        level = Defaults[.level]
    }
}