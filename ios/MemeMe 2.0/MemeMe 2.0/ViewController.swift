//
//  ViewController.swift
//  MemeMe 2.0
//
//  Created by linlinno on 2017/3/16.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{

    @IBOutlet weak var imagePickView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    
    var memedImage:UIImage!
    var isTopTextField:Bool = true
    
    let memeTextAttributes:[String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.0]
    
//    隐藏状态栏
//    全局设置方法
//   （1）在 Info.plist 中添加如下配置
//    <key>UIViewControllerBasedStatusBarAppearance</key><false/>
//   （2）在 General -> Deployment Info 中，将 Hide status bar 勾选
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置textfield代理
        self.topTextField.delegate = self
        self.bottomTextField.delegate = self
        //设置textfield属性
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.center
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.center
                
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("ViewController-viewWillAppear")
        super.viewWillAppear(animated)
        //判断手机能不能拍照
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        //注册键盘通知
        subscribeToKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("ViewController-viewWillDisappear")
        super.viewWillDisappear(animated)
        //注销键盘通知
        unsubscribeFromKeyboardNotifications()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func keyboardWillShow(_ notification:Notification) {
        if(isTopTextField){
            view.frame.origin.y = 0
        }else{
            view.frame.origin.y = 0 - getKeyboardHeight(notification)
        }
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
    
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takeAphoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    //UIImagePickerControllerDelegate
    //选了照片
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        //print("imagePickerController")
        print(info)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imagePickView.image = image
        }
        
        //关闭imagePicker
        dismiss(animated: true, completion: nil)
    }

    //UIImagePickerControllerDelegate
    //没选照片
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        //print("imagePickerControllerDidCancel")
        //关闭imagePicker
        dismiss(animated: true, completion: nil)
    }
    
    
    //UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField){
        if(textField == self.topTextField){
            isTopTextField = true
        }else{
            isTopTextField = false
        }
        textField.text = ""
    }
    
    @IBAction func sharePhoto(_ sender: Any) {
        print("ViewController-sharephoto")
//      generate a memed image
        self.memedImage = generateMemedImage()
//      define an instance of the ActivityViewController
//      pass the ActivityViewController a memedImage as an activity item
        let vc = UIActivityViewController(activityItems: [self.memedImage], applicationActivities: nil)
//      present the ActivityViewController
        present(vc, animated: true, completion: nil)
        
        vc.completionWithItemsHandler = {(activity, success, items, error)->Void in
            if success {
                //分享成功之后保存
                self.save()
                //完成之后回到上一个界面
                self.goback()
            }
            vc.completionWithItemsHandler = nil
        }
    }
    
    //回到上一个界面
    @IBAction func cancel(_ sender: Any) {
        print("cancel")
        goback()
    }
    
    func goback(){
        if let navigationController = self.navigationController {
            //navigationController.popToRootViewController(animated: true)
            navigationController.popViewController(animated: true)
        }
    }
    
    func save() {
        print("ViewController-save")
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickView.image!, memedImage: self.memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        print("ViewController-generateMemedImage")
        // Hide toolbar and navbar
        toolbar.isHidden = true
        navbar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        toolbar.isHidden = false
        navbar.isHidden = false
        return memedImage
    }
}



