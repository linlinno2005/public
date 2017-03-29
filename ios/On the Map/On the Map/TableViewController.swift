//
//  TableViewController.swift
//  On the Map
//
//  Created by linlinno on 2017/3/21.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    var studentLocations:[Constants.StudentLocation] = []
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        //print("TableViewController...viewDidLoad")
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.appDelegate.isUpdateTable = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //print("TableViewController...viewWillAppear")
        super.viewWillAppear(animated)
        studentLocations = appDelegate.studentLocations
        //更新table
        if(self.appDelegate.isUpdateTable){
            getStudentLocations(completionHandler:refreshDate)
            self.appDelegate.isUpdateTable = false
        }
        //恢复tabbar和navbar
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath)
        let row = self.studentLocations[indexPath.row]
        
        cell.imageView?.image = UIImage(named:"icon_pin")
        var name = String(indexPath.row + 1) + ". "
        name = name + row.firstName
        name = name + " "
        name = name + row.lastName
        cell.textLabel?.text = name
        return cell
    }
    
    //响应item点击事件
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mediaUrl = studentLocations[indexPath.row].mediaURL
        
        let app = UIApplication.shared
        if let url = URL(string: mediaUrl){
            app.open(url, options: [:], completionHandler: nil)
        }
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
    
    func refreshDate(locations:[Constants.StudentLocation]){
        self.appDelegate.studentLocations = locations
        self.studentLocations = locations
        self.tableView.reloadData()
    }
    
    @IBAction func refreshTable(_ sender: Any) {
        getStudentLocations(completionHandler:refreshDate)
    }
    
}
