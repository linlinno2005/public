//
//  Constants.swift
//  On the Map
//
//  Created by linlinno on 2017/3/21.
//  Copyright © 2017年 linlinno. All rights reserved.
//
import UIKit

struct Constants {
    
    struct Udacity{
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPathSession = "/api/session"
        static let ApiPathUsers = "/api/users"
    }
    
    struct MapAPI {
        static let APIScheme = "https"
        static let APIHost = "parse.udacity.com"
        static let APIPath = "/parse/classes/StudentLocation"
        static let APPID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    struct LocationKeys {
        static let CreatedAt = "createdAt"
        static let FirstName = "firstName"
        static let  LastName = "lastName"
        static let  Latitude = "latitude"
        static let  Longitude = "longitude"
        static let  MapString = "mapString"
        static let  MediaURL = "mediaURL"
        static let  ObjectId = "objectId"
        static let  UniqueKey = "uniqueKey"
        static let  UpdatedAt = "updatedAt"
    }
    
    static let overWriteAlert = "You Have Already Post A Student Location.Would You Like To Overwrite Your Current Location?"
    static let enterAgainAlert = "Can not find this Location on the map,please enter again."
    static let studentLocationBody = "{\"uniqueKey\": \"<uniqueKey>\", \"firstName\": \"<firstName>\", \"lastName\": \"<lastName>\",\"mapString\": \"<mapString>\", \"mediaURL\": \"<mediaURL>\",\"latitude\": <latitude>, \"longitude\": <longitude>}"
    static let signUP = "Don't have a account? Sign up"
    
    static let defaultUrl = "https://www.udacity.com"
    static let signUPUrl = "https://auth.udacity.com/sign-up"
    
    
    struct AccountInfo {
        var sessionId:String
        var accountKey:String
        var firstName:String
        var lastName:String
        
        init() {
            sessionId = ""
            accountKey = ""
            firstName = ""
            lastName = ""
        }
    }
    
    struct StudentLocation {
        var createdAt:String
        var firstName:String
        var lastName:String
        var latitude:Double
        var longitude:Double
        var mapString:String
        var mediaURL:String
        var objectId:String
        var uniqueKey:String
        var updatedAt:String
        
        init() {
            createdAt=""
            firstName=""
            lastName=""
            latitude=0
            longitude=0
            mapString=""
            mediaURL=""
            objectId=""
            uniqueKey=""
            updatedAt=""
        }
    }
}

extension String
{
    func trim() -> String
    {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
    }
}
