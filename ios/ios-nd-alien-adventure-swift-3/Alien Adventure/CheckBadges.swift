//
//  CheckBadges.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func checkBadges(badges: [Badge], requestTypes: [UDRequestType]) -> Bool {
        
        for requestType in requestTypes{
            var flag = false
            for badge in badges{
                if(requestType.rawValue == badge.requestType.rawValue){
                    flag = true
                }
            }
            if(!flag){
                return false
            }
        }
        return true
    }
    
}
