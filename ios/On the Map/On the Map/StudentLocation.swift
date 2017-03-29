//
//  StudentLocation.swift
//  On the Map
//
//  Created by linlinno on 2017/3/23.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import Foundation

//获取学生位置列表
func getStudentLocations(completionHandler:@escaping ([Constants.StudentLocation])->Void){
    
    var studentLocations:[Constants.StudentLocation]=[]
    
    let request = NSMutableURLRequest(url: URL(string: Constants.MapAPI.APIScheme+"://"+Constants.MapAPI.APIHost+Constants.MapAPI.APIPath)!)
    request.addValue(Constants.MapAPI.APPID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(Constants.MapAPI.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        if error != nil {
            print("[error]:","GetStudentLocations failed")
            return
        }
        
        //判断状态值
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("[error]:","Status code is not 2xx!")
            return
        }
        
        //判断是否有data
        guard let newData = data else {
            print("[error]:","Data is nil")
            return
        }
        
        
        //json解析
        //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        
        let parsedResult: [String:Any]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:Any]
        } catch let error as Error!{
            print("[error]:",error)
            return
        }
        
        //print(parsedResult["results"])
        //清洗数据，有的数据不完整需补齐，避免之后处理出现异常
        if let results = parsedResult["results"] as? [[String:Any]]{
            //print("results count:",results.count)
            for location in results{
                if(location.keys.contains(Constants.LocationKeys.CreatedAt)
                    && location.keys.contains(Constants.LocationKeys.FirstName)
                    && location.keys.contains(Constants.LocationKeys.LastName)
                    && location.keys.contains(Constants.LocationKeys.Latitude)
                    && location.keys.contains(Constants.LocationKeys.Longitude)
                    && location.keys.contains(Constants.LocationKeys.MapString)
                    && location.keys.contains(Constants.LocationKeys.MediaURL)
                    && location.keys.contains(Constants.LocationKeys.ObjectId)
                    && location.keys.contains(Constants.LocationKeys.UniqueKey)
                    && location.keys.contains(Constants.LocationKeys.UpdatedAt)){
                    
                    var studentLocation:Constants.StudentLocation = Constants.StudentLocation()
                    
                    studentLocation.firstName = location[Constants.LocationKeys.FirstName] as! String
                    studentLocation.lastName = location[Constants.LocationKeys.LastName] as! String
                    studentLocation.createdAt = location[Constants.LocationKeys.CreatedAt] as! String
                    studentLocation.latitude = location[Constants.LocationKeys.Latitude] as! Double
                    studentLocation.longitude = location[Constants.LocationKeys.Longitude] as! Double
                    studentLocation.mapString = location[Constants.LocationKeys.MapString] as! String
                    studentLocation.mediaURL = location[Constants.LocationKeys.MediaURL] as! String
                    studentLocation.objectId = location[Constants.LocationKeys.ObjectId] as! String
                    studentLocation.uniqueKey = location[Constants.LocationKeys.UniqueKey] as! String
                    studentLocation.updatedAt = location[Constants.LocationKeys.UpdatedAt] as! String
                    
                    
                    if(studentLocation.firstName.trim()=="")&&(studentLocation.lastName.trim()==""){
                        //                        print("@@@@@@@location count:",location.count)
                        //                        print(location)
                    }else{
                        studentLocations.append(studentLocation)
                    }
                    
                }else{
                    //                    print("@@@@@@@location count:",location.count)
                    //                    print(location)
                }
            }
        }
        
        completionHandler(studentLocations)
        
    }
    task.resume()
}

//获取一个学生位置
func getAStudentLocation(uniqueKey:String,completionHandler:@escaping (String)->Void){
    let tail = "{\"uniqueKey\":\""+uniqueKey+"\"}"
    let escapedTail = tail.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    let urlString = Constants.MapAPI.APIScheme+"://"+Constants.MapAPI.APIHost+Constants.MapAPI.APIPath+"?where=" + escapedTail!
    let url = URL(string: urlString)
    let request = NSMutableURLRequest(url: url!)
    request.addValue(Constants.MapAPI.APPID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(Constants.MapAPI.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        if error != nil {
            print("[error]:","getAStudentLocation failed")
            return
        }
        
        //判断状态值
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("[error]:","Status code is not 2xx!")
            return
        }
        
        //判断是否有data
        guard let newData = data else {
            print("[error]:","Data is nil")
            return
        }
        
        //json解析
        //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        let parsedResult: [String:Any]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as! [String:Any]
        } catch let error as Error!{
            print("[error]:",error)
            return
        }
        
        if let results = parsedResult["results"] as? [[String:Any]]{
            //            print("results count:",results.count)
            
            if(results.count > 0){
                //                print(results[0][Constants.LocationKeys.ObjectId])
                
                performUIUpdatesOnMain {
                    completionHandler(results[0][Constants.LocationKeys.ObjectId] as! String)
                }
            }else{
                performUIUpdatesOnMain {
                    completionHandler("")
                }
            }
        }else{
            performUIUpdatesOnMain {
                completionHandler("")
            }
        }
    }
    task.resume()
}

//创建一个学生位置
func createAStudentLocation(location:Constants.StudentLocation,completionHandler:@escaping ()->Void){
    let request = NSMutableURLRequest(url: URL(string: Constants.MapAPI.APIScheme+"://"+Constants.MapAPI.APIHost+Constants.MapAPI.APIPath)!)
    request.httpMethod = "POST"
    request.addValue(Constants.MapAPI.APPID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(Constants.MapAPI.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    var httpBody = Constants.studentLocationBody.replacingOccurrences(of: "<"+Constants.LocationKeys.FirstName+">", with: location.firstName)
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.LastName+">", with: location.lastName)
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.Longitude+">", with: String(location.longitude))
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.Latitude+">", with: String(location.latitude))
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.MapString+">", with: location.mapString)
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.MediaURL+">", with: location.mediaURL)
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.UniqueKey+">", with: location.uniqueKey)
    request.httpBody = httpBody.data(using: String.Encoding.utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        if error != nil {
            print("createAStudentLocation failed")
            return
        }
        //先判断状态值
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("[error]:","Status code is not 2xx!")
            return
        }
        //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        
        performUIUpdatesOnMain {
            completionHandler()
        }
    }
    task.resume()
}

//更新一个学生位置
func updateAStudentLocation(location:Constants.StudentLocation,completionHandler:@escaping ()->Void){
    let urlString = Constants.MapAPI.APIScheme+"://"+Constants.MapAPI.APIHost+Constants.MapAPI.APIPath+"/"+location.objectId
    let url = URL(string: urlString)
    let request = NSMutableURLRequest(url: url!)
    request.httpMethod = "PUT"
    request.addValue(Constants.MapAPI.APPID, forHTTPHeaderField: "X-Parse-Application-Id")
    request.addValue(Constants.MapAPI.APIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    var httpBody = Constants.studentLocationBody.replacingOccurrences(of: "<"+Constants.LocationKeys.FirstName+">", with: location.firstName)
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.LastName+">", with: location.lastName)
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.Longitude+">", with: String(location.longitude))
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.Latitude+">", with: String(location.latitude))
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.MapString+">", with: location.mapString)
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.MediaURL+">", with: location.mediaURL)
    httpBody = httpBody.replacingOccurrences(of: "<"+Constants.LocationKeys.UniqueKey+">", with: location.uniqueKey)
    request.httpBody = httpBody.data(using: String.Encoding.utf8)
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
        if error != nil { // Handle error…
            print("updateAStudentLocation failed")
            return
        }
        //先判断状态值
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
            print("[error]:","Status code is not 2xx!")
            return
        }
        
        //print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
        
        performUIUpdatesOnMain {
            completionHandler()
        }
    }
    task.resume()
}


