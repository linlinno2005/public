//
//  LinkViewController.swift
//  On the Map
//
//  Created by linlinno on 2017/3/23.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class LinkViewController: UIViewController,MKMapViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var linkTextField: UITextField!
    var pinLocation:Constants.StudentLocation = Constants.StudentLocation()
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.linkTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册键盘通知
        subscribeToKeyboardNotifications()
        //隐藏tabbar和navbar
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        //根据地名查询坐标位置
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(self.appDelegate.mapStirng, completionHandler: getCoordinateByAddress)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //注销键盘通知
        unsubscribeFromKeyboardNotifications()
        //恢复tabbar和navbar
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func goback(action:UIAlertAction){
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
            //navigationController.popViewController(animated: true)
        }
    }
    
    //根据地名确定地理坐标
    func getCoordinateByAddress(pls: [CLPlacemark]?, error: Error?){
        if(error != nil){
            print("getCoordinateByAddress failed")
            
            let alertController = UIAlertController(title: nil, message: Constants.enterAgainAlert, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Confirm", style: .default, handler: goback))
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
        let placemark=(pls?[0])! as CLPlacemark
        let location=placemark.location//位置
//        let region=placemark.region//区域
//        let addressDic = placemark.addressDictionary//详细地址信息字典,包含以下部分信息
//        let name=placemark.name;//地名
//        let thoroughfare=placemark.thoroughfare;//街道
//        let subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
//        let locality=placemark.locality; // 城市
//        let subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
//        let administrativeArea=placemark.administrativeArea; // 州
//        let subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
//        let postalCode=placemark.postalCode; //邮编
//        let ISOcountryCode=placemark.isoCountryCode; //国家编码
//        let country=placemark.country; //国家
//        let inlandWater=placemark.inlandWater; //水源、湖泊
//        let ocean=placemark.ocean; // 海洋
//        let areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
//        print("[位置]",location)
//        print("[名字]",name)
//        print("[国家]",country)
        
        pinLocation.latitude = (location?.coordinate.latitude)!
        pinLocation.longitude = (location?.coordinate.longitude)!
        
        print(pinLocation.latitude)
        print(pinLocation.longitude)
        
        let coordinate = CLLocationCoordinate2D(latitude: pinLocation.latitude, longitude: pinLocation.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        self.mapView.addAnnotation(annotation)
        
        //创建一个MKCoordinateSpan对象，设置地图的范围（越小越精确）
        let latDelta = 0.05
        let longDelta = 0.05
        let currentLocationSpan:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        //定义地图区域和中心坐标（
        //使用自定义位置
        let currentRegion:MKCoordinateRegion = MKCoordinateRegion(center: coordinate,span: currentLocationSpan)
        
        //设置显示区域
        self.mapView.setRegion(currentRegion, animated: true)
    }
    
    //键盘通知
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func keyboardWillHide(_ notification:Notification){
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    //UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField){
        textField.text = ""
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
            //navigationController.popViewController(animated: true)
        }
    }
    
    func goToTabView(){
        self.appDelegate.isUpdateMap = true
        self.appDelegate.isUpdateTable = true
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
            //navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func submitLocation(_ sender: Any) {
        pinLocation.firstName = self.appDelegate.accountInfo.firstName
        pinLocation.lastName = self.appDelegate.accountInfo.lastName
        pinLocation.mapString = self.appDelegate.mapStirng
        if(linkTextField.text != nil)&&(linkTextField.text != ""){
            pinLocation.mediaURL = linkTextField.text!.trim()
        }else{
            pinLocation.mediaURL = Constants.defaultUrl
        }
        pinLocation.objectId = self.appDelegate.objectId
        pinLocation.uniqueKey = self.appDelegate.accountInfo.accountKey
        
        if(self.appDelegate.isOverwrite){
            updateAStudentLocation(location: pinLocation,completionHandler:goToTabView)
        }else{
            createAStudentLocation(location: pinLocation,completionHandler:goToTabView)
        }
    }
        
}
