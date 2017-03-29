//
//  ViewController.swift
//  On the Map
//
//  Created by linlinno on 2017/3/20.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate,UITextViewDelegate {
    
    var appDelegate: AppDelegate!
    
    @IBOutlet weak var usrNameTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var signUpTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取app代理
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        //设置代理
        self.usrNameTextField.delegate = self
        self.pwdTextField.delegate = self
        self.signUpTextView.delegate = self
        //处理sign up超链接
        self.setSignUpLink()
    }
    
    func setSignUpLink(){
        let linkAttributes = [
            NSLinkAttributeName: NSURL(string: Constants.signUPUrl)!,
            NSForegroundColorAttributeName: UIColor.blue,
            NSFontAttributeName: UIFont(name: "Arial", size: 18)!,
            ] as [String : Any]
        
        let normalAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "Arial", size: 18)!,
            ] as [String:Any]
        
        let attributedString = NSMutableAttributedString(string: Constants.signUP)
        
        attributedString.setAttributes(normalAttributes,range: NSMakeRange(0, 22))
        // Set the 'sign up' substring to be the link
        attributedString.setAttributes(linkAttributes, range: NSMakeRange(22, 7))
        
        self.signUpTextView.attributedText = attributedString
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //注册键盘通知
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //注销键盘通知
        unsubscribeFromKeyboardNotifications()
    }
    
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
    
    @IBAction func login(_ sender: Any) {
        //参数检查
        if usrNameTextField.text!.trim() == "" || pwdTextField.text!.trim() == ""{
            debugLabel.text = "Username or Password Empty."
            return
        }
        
        //设置用户名密码按钮不可重复点击
        enableEdit(isOn: false)
        //登陆
        postASession(usr: usrNameTextField.text!,pwd:pwdTextField.text!)
    }
    
    func enableEdit(isOn:Bool){
        if(isOn){
            self.usrNameTextField.isEnabled = true
            self.pwdTextField.isEnabled = true
            self.loginButton.isEnabled = true
            self.usrNameTextField.backgroundColor = UIColor.white
            self.pwdTextField.backgroundColor = UIColor.white
        }else{
            self.usrNameTextField.isEnabled = false
            self.pwdTextField.isEnabled = false
            self.loginButton.isEnabled = false
            self.usrNameTextField.backgroundColor = UIColor.lightGray
            self.pwdTextField.backgroundColor = UIColor.lightGray
        }
    }
    
    
    func postASession(usr:String,pwd:String){
        let url = Constants.Udacity.ApiScheme+"://"+Constants.Udacity.ApiHost+Constants.Udacity.ApiPathSession
        let request = NSMutableURLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let querry = "{\"udacity\": {\"username\": \"" + usr+"\", \"password\": \"" + pwd + "\"}}"
        //print("[querry]:"+querry)
        request.httpBody = querry.data(using: String.Encoding.utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            //请求出错
            guard (error == nil) else{
                performUIUpdatesOnMain{
                    self.debugLabel.text = "Login failed"
                }
                self.enableEdit(isOn: true)
                return
            }
            
            //先判断状态值
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                performUIUpdatesOnMain{
                    self.debugLabel.text = "Status code is not 2xx!"
                }
                self.enableEdit(isOn: true)
                return
            }
            
            //判断是否有data
            guard let newData = data else {
                performUIUpdatesOnMain{
                    self.debugLabel.text = "data is nil"
                }
                self.enableEdit(isOn: true)
                return
            }
            
            //json解析，前几位是垃圾数据
            let range = Range(uncheckedBounds: (5, data!.count))
            let cleanData = newData.subdata(in: range)
            //print("[data]:",String(data: cleanData, encoding: String.Encoding.utf8)! as String)
            
            let parsedResult: [String:Any]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: cleanData, options: .allowFragments) as! [String:Any]
            } catch let error as Error!{
                performUIUpdatesOnMain{
                    self.debugLabel.text = "JSON parse erro: '\(data)'"
                    print("[error]:",error)
                }
                self.enableEdit(isOn: true)
                return
            }
            
            //print(parsedResult)
            if let session = parsedResult["session"] as? [String:Any]{
                self.appDelegate.accountInfo.sessionId = session["id"] as! String
                print("session_id",session["id"] as Any )
                print("session_expiration",session["expiration"] as Any)
                
            }
            
            if let account = parsedResult["account"] as? [String:Any]{
                self.appDelegate.accountInfo.accountKey = account["key"] as! String
                print("account_key",account["key"] as Any)
                print("account_registered",account["registered"]as Any)
                self.getPublicUserData(userID: self.appDelegate.accountInfo.accountKey)
            }
            
            //进入on the map
            performUIUpdatesOnMain{
                let vc = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
                self.present(vc, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    func getPublicUserData(userID:String){
        let url = Constants.Udacity.ApiScheme+"://"+Constants.Udacity.ApiHost+Constants.Udacity.ApiPathUsers+"/"+userID
        let request = NSMutableURLRequest(url: URL(string: url)!)
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                print("getPublicUserData failed")
                return
            }
            
            //先判断状态值
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Status code is not 2xx!")
                return
            }
            
            //判断是否有data
            guard let newData = data else {
                print("data is nil")
                return
            }
            
            //json解析，前几位是垃圾数据
            let range = Range(uncheckedBounds: (5, data!.count))
            let cleanData = newData.subdata(in: range)
            //print("[data]:",String(data: cleanData, encoding: String.Encoding.utf8)! as String)
            
            let parsedResult: [String:Any]!
            do {
                parsedResult = try JSONSerialization.jsonObject(with: cleanData, options: .allowFragments) as! [String:Any]
            } catch let error as Error!{
                print("[error]:",error)
                return
            }
            
            //print(parsedResult)
            if let user = parsedResult["user"] as? [String:Any]{
                self.appDelegate.accountInfo.firstName = user["first_name"] as! String
                self.appDelegate.accountInfo.lastName = user["last_name"] as! String
                
                print("firstName:",self.appDelegate.accountInfo.firstName)
                print("lastName:",self.appDelegate.accountInfo.lastName)
            }
            
        }
        task.resume()
    }
}



