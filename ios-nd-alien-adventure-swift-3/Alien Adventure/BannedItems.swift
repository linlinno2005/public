//
//  BannedItems.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import Foundation

extension Hero {
    
    func bannedItems(dataFile: String) -> [Int] {
        
        var itemIDs = [Int]()
        
        //open plsit file
        let dataFileURL = Bundle.main.url(forResource: dataFile, withExtension: "plist")!
        let itemArray = NSArray(contentsOf : dataFileURL ) as! [[String:Any]]
        
        //find banneditems
        var containsLaser = false
        var lessThan30 = false
        var bannedItemID = 0
        for item in itemArray{
            containsLaser = false
            lessThan30 = false
            if let name = item["Name"] as? String{
                if(name.contains("laser") || name.contains("Laser")){
                    containsLaser = true
                }
            }
            
            if let historicalDate = item["HistoricalData"] as? [String:Any]{
                if let carbonAge = historicalDate["CarbonAge"] as? Int{
                    if(carbonAge < 30){
                        lessThan30 = true
                    }
                }
            }
            
            if let itemID = item["ItemID"] as? Int{
                bannedItemID = itemID
            }
            
            if(containsLaser && lessThan30){
                itemIDs.append(bannedItemID)
            }
        }

        return itemIDs
    }
}

// If you have completed this function and it is working correctly, feel free to skip this part of the adventure by opening the "Under the Hood" folder, and making the following change in Settings.swift: "static var RequestsToSkip = 6"
