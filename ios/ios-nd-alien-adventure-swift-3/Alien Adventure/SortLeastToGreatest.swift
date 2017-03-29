//
//  SortLeastToGreatest.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func sortLeastToGreatest(inventory: [UDItem]) -> [UDItem] {
        
        let sortedInventory = inventory.sorted(by: { (item1:UDItem, item2:UDItem) -> Bool in
            if(item1.rarity.rawValue < item2.rarity.rawValue){
                return true
            }
            if(item1.rarity.rawValue == item2.rarity.rawValue)&&(item1.baseValue < item2.baseValue){
                return true
            }
            return false
        })
        return sortedInventory
    }
    
}

// If you have completed this function and it is working correctly, feel free to skip this part of the adventure by opening the "Under the Hood" folder, and making the following change in Settings.swift: "static var RequestsToSkip = 5"
