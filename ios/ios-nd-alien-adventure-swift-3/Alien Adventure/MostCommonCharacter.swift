//
//  MostCommonCharacter.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func mostCommonCharacter(inventory: [UDItem]) -> Character? {
        
        var charDic = [Character:Int]()
        var mostCommonChar:Character? = nil
        
        for item in inventory{

            for charInName in item.name.lowercased().characters{
                if let count = charDic[charInName]{
                    charDic[charInName] = count + 1
                }else{
                    charDic[charInName] = 1
                }
            }
        }
        
        var count = 0
        for charInDic in charDic{
            if(charInDic.value > count){
                count = charInDic.value
                mostCommonChar = charInDic.key
            }
        }
        
        return mostCommonChar
    }
}
