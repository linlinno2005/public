//
//  PolicingItems.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func policingItems(inventory: [UDItem], policingFilter: (UDItem) throws -> Void) -> [UDPolicingError:Int] {
        var itemsDic = [UDPolicingError:Int]()
        itemsDic[UDPolicingError.itemFromCunia] = 0
        itemsDic[UDPolicingError.nameContainsLaser] = 0
        itemsDic[UDPolicingError.valueLessThan10] = 0

        for item in inventory{
            do {
                try policingFilter(item)
            }catch UDPolicingError.itemFromCunia{
                //print("We caught itemFromCunia")
                itemsDic[UDPolicingError.itemFromCunia] =  itemsDic[UDPolicingError.itemFromCunia]! + 1
            }catch UDPolicingError.nameContainsLaser{
                //print("We caught nameContainsLaser")
                itemsDic[UDPolicingError.nameContainsLaser] =  itemsDic[UDPolicingError.nameContainsLaser]! + 1
            }catch UDPolicingError.valueLessThan10{
                //print("We caught valueLessThan10")
                itemsDic[UDPolicingError.valueLessThan10] =  itemsDic[UDPolicingError.valueLessThan10]! + 1
            }catch{
                print("We caught an error")
            }
        }
        return itemsDic
    }    
}

// If you have completed this function and it is working correctly, feel free to skip this part of the adventure by opening the "Under the Hood" folder, and making the following change in Settings.swift: "static var RequestsToSkip = 1"
