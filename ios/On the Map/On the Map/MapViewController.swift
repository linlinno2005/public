//
//  MapViewController.swift
//  On the Map
//
//  Created by linlinno on 2017/3/21.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate {
    
    @IBOutlet var mapView: MKMapView!
    
    var studentLocations:[Constants.StudentLocation] = []
    var appDelegate: AppDelegate!
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        mapView.delegate = self
        self.appDelegate.isUpdateMap = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //获取学生位置信息
        if(self.appDelegate.isUpdateMap){
            self.mapView.removeAnnotations(annotations)
            getStudentLocations(completionHandler:addAnnotations)
            self.appDelegate.isUpdateMap = false
        }
        //恢复tabbar和navbar
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //复用pin视图
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //是否开注解视图
            pinView!.canShowCallout = true
            //注解视图是否可跳转
            if let subtitle = annotation.subtitle!,let _ = URL(string:subtitle){
                pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            }
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    //响应pin的点击事件
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,let url = URL(string: toOpen){
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func addAnnotations(locations:[Constants.StudentLocation]){
        self.appDelegate.studentLocations = locations
        annotations.removeAll()
        
        for location in locations {
            
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName) \(location.lastName)"
            annotation.subtitle = location.mediaURL
            
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
    }
    
    func showPinView(){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    func overWrite(action:UIAlertAction){
        self.appDelegate.isOverwrite = true
        showPinView()
    }
    
    func newOrUpdate(objectID:String){
        self.appDelegate.objectId = objectID
        if(objectID == ""){
            self.appDelegate.isOverwrite = false
            self.showPinView()
        }else{
            let alertController = UIAlertController(title: nil, message: Constants.overWriteAlert, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: overWrite))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func pinMyself(_ sender: Any) {
        getAStudentLocation(uniqueKey: self.appDelegate.accountInfo.accountKey,completionHandler: newOrUpdate)
    }
    
    @IBAction func refreshMap(_ sender: Any) {
        self.mapView.removeAnnotations(annotations)
        getStudentLocations(completionHandler:addAnnotations)
    }
    
}
