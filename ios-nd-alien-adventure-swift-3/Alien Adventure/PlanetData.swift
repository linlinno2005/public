//
//  PlanetData.swift
//  Alien Adventure
//
//  Created by Jarrod Parkes on 10/4/15.
//  Copyright © 2015 Udacity. All rights reserved.
//
import Foundation

extension Hero {
    
    func planetData(dataFile: String) -> String {
        
        //open json file
        let dataFileURL = Bundle.main.url(forResource: dataFile, withExtension: "json")!
        let rawPlanetJson = try! Data(contentsOf : dataFileURL)
        
        //find planet
        var planetDicFromJson:[[String:Any]]!
        do{
            planetDicFromJson = try! JSONSerialization.jsonObject(with: rawPlanetJson, options:JSONSerialization.ReadingOptions()) as! [[String:Any]]
        }
        
        var highestPointsName = ""
        var highestPoints = 0
        var points = 0
        
        for plant in planetDicFromJson{
            points = 0
            if let commonNum = plant["CommonItemsDetected"] as? Int{
                points += commonNum * 1
            }
            if let uncommonNum = plant["UncommonItemsDetected"] as? Int{
                points += uncommonNum * 2
                
            }
            if let rareNum = plant["RareItemsDetected"] as? Int{
                points += rareNum * 3
                
            }
            if let legendaryNum = plant["LegendaryItemsDetected"] as? Int{
                points += legendaryNum * 4
            }
            
            if(highestPoints < points){
                highestPoints = points
                
                if let name = plant["Name"] as? String{
                    highestPointsName = name
                }
            }
        }
        return highestPointsName
    }
}

// If you have completed this function and it is working correctly, feel free to skip this part of the adventure by opening the "Under the Hood" folder, and making the following change in Settings.swift: "static var RequestsToSkip = 7"
