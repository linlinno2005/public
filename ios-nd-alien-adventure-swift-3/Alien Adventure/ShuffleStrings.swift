//
//  ShuffleStrings.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 9/30/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

extension Hero {
    
    func shuffleStrings(s1: String, s2: String, shuffle: String) -> Bool {

        if((s1.characters.count == 0)
            && (s2.characters.count == 0)
            && (shuffle.characters.count == 0)){
          return true
        }
        
        var preIndexS1 = 0
        var preIndexS2 = 0
        var index = 0
        
        if(shuffle.characters.count == (s1.characters.count + s2.characters.count) ){
            for char in shuffle.characters{
                if( !s1.contains(String(char)) && !s2.contains(String(char))){
                    return false
                }

                index = 0
                for charS1 in s1.characters{
                    if(char == charS1){
                        if(preIndexS1 > index){
                            return false
                        }
                        preIndexS1 = index
                    }
                    index += 1
                }
                
                index = 0
                for charS2 in s2.characters{
                    print(charS2)
                    if(char == charS2){
                        if(preIndexS2 > index){
                            return false
                        }
                        preIndexS2 = index
                    }
                    index += 1
                }
            }
            return true

        }else{
           return false
        }
    }
}
