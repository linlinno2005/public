//
//  RarityOfItems.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func rarityOfItems(inventory: [UDItem]) -> [UDItemRarity:Int] {
        
        var items = [UDItemRarity:Int]()
        var commonNum = 0;
        var uncommonNum = 0
        var rareNum = 0
        var legendaryNum = 0
        
        for item in inventory {
            switch item.rarity {
            case .common:
                commonNum += 1
            case .uncommon:
                uncommonNum += 1
            case .rare:
                rareNum += 1
            case .legendary:
                legendaryNum += 1
            }
        }

        items[UDItemRarity.common] = commonNum
        items[UDItemRarity.uncommon] = uncommonNum
        items[UDItemRarity.rare] = rareNum
        items[UDItemRarity.legendary] = legendaryNum
        
        return items
    }
}

// If you have completed this function and it is working correctly, feel free to skip this part of the adventure by opening the "Under the Hood" folder, and making the following change in Settings.swift: "static var RequestsToSkip = 4"
