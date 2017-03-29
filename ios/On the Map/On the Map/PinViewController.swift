//
//  PinViewController.swift
//  On the Map
//
//  Created by linlinno on 2017/3/21.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import UIKit

class PinViewController: UIViewController,UITextFieldDelegate {
    
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var mapStringTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.mapStringTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册键盘通知
        subscribeToKeyboardNotifications()
        //隐藏tabbar和navbar
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //注销键盘通知
        unsubscribeFromKeyboardNotifications()
        //恢复tabbar和navbar
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    //键盘通知
    func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = 0 - getKeyboardHeight(notification)
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
        print("cancel")
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
            //navigationController.popViewController(animated: true)
        }
    }
    
    func showLinkView(){
        let vc = self.storyboard!.instantiateViewController(withIdentifier: "LinkViewController") as! LinkViewController
        self.navigationController!.pushViewController(vc, animated: true)
    }
    
    @IBAction func findOnTheMap(_ sender: Any) {
        //print("find on the map")
        
        if let mapString = mapStringTextField.text{
            self.appDelegate.mapStirng = mapString
            showLinkView()
        }
    }
    
}
