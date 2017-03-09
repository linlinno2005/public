//
//  RemoveDuplicates.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func removeDuplicates(inventory: [UDItem]) -> [UDItem] {
        
        var newInventory = [UDItem]()
        for itemInOldInventory in inventory{
            var isNew = true
            for itemInNewInventory in newInventory{
                if(itemInNewInventory.hashValue == itemInOldInventory.hashValue){
                    isNew = false
                }
            }
            if(isNew){
                newInventory.append(itemInOldInventory)
            }
        }
        return newInventory
    }
    
}
