//
//  ViewController.swift
//  Bear Weather
//
//  Created by linlinno on 2017/3/10.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherInfo: UITextView!
    @IBOutlet weak var beijingButton: UIButton!
    @IBOutlet weak var shanghaiButton: UIButton!
    @IBOutlet weak var shenzhenButton: UIButton!
    @IBOutlet weak var hkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func beijingWeather(_ sender: Any) {
        getWeatherCurrent(city: "beijing",country: "cn")
    }
    
    @IBAction func shanghaiWeather(_ sender: Any) {
        getWeatherCurrent(city: "shanghai",country: "cn")
    }
    
    @IBAction func guangzhouWeather(_ sender: Any) {
        getWeatherCurrent(city: "guangzhou",country: "cn")
    }
    
    @IBAction func shenzhenWeather(_ sender: Any) {
        getWeatherCurrent(city: "shenzhen",country: "cn")
    }
    
    @IBAction func hkWeather(_ sender: Any) {
        getWeatherCurrent(city: "hongkong",country: "hongkong")
    }
    
    let weatherCurrent = "http://api.openweathermap.org/data/2.5/weather?q={city_name},{country_code}&units=metric&appid=390599e097b012fed327ecc148a15637"
    
    let weatherForecast = "http://api.openweathermap.org/data/2.5/forecast?q={city_name},{country_code}&units=metric&appid=390599e097b012fed327ecc148a15637"
    
    
    //这个函数会立即返回，但是网络访问解析那一段会另开一个线程
    func getWeatherCurrent(city:String,country:String)->Void{
        
        let weatherURLString = weatherCurrent
            .replacingOccurrences(of: "{city_name}",with:city)
            .replacingOccurrences(of: "{country_code}",with:country)
        print("@@@@@@@@@@@@@@@@@@@@@@")
        //print(weatherURLString)
        var returnString = "city:"+city+"\n"
        
        if let weatherURL = URL.init(string: weatherURLString){
            URLSession.shared.dataTask(with: weatherURL){ data, response, error in
                if let jsonDate = data{
                    do{
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: jsonDate, options:JSONSerialization.ReadingOptions.mutableContainers)
                        //print(jsonResult)
                        if let jsonDic = jsonResult as? [String: Any]{
                            if let temp = jsonDic["main"] as? [String :Any]{
                                if let tempC = temp["temp"] as? Int{
                                    //print(tempC)
                                    returnString = returnString+"temputure:"+String(tempC)+"°C\n"
                                }else{
                                    
                                    print("get temp failed")
                                }
                            }
                            if let weather = jsonDic["weather"] as? [[String:Any]]{
                                returnString = returnString + "weather:"
                                for weatherItem in weather{
                                    if let weatherMain = weatherItem["main"] as? String{
                                        //print(weatherMain)
                                        returnString = returnString+weatherMain+" "
                                    }else{
                                        print("get weather failed")
                                    }
                                }
                            }
                            
                            DispatchQueue.main.async {
                                self.weatherInfo.text = returnString
                            }
                            print("returnString:\n"+returnString)
                        }
                    }catch{
                        print("json processing failed")
                    }
                }else{
                    print("jsonDate is nil")
                }
                
            }.resume()
        }
    }
}






