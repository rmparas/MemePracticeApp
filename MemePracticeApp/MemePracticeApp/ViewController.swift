//
//  ViewController.swift
//  MemePracticeApp
//
//  Created by Rod Paras on 5/9/15.
//  Copyright (c) 2015 Rodacity. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topField: UITextField!

    @IBOutlet weak var bottomField: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var bottomTab: UIToolbar!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    
    var memeImageTemp: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
        self.setInitialScreenSettings()
    }

    func setInitialScreenSettings() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "Return",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "returnToViewController")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Action,
            target: self,
            action: "shareMeme")
        
        topField.hidden = true
        bottomField.hidden = true
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.redColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSStrokeWidthAttributeName : 4.0
        ]
        
        topField.defaultTextAttributes = memeTextAttributes
        topField.textAlignment = NSTextAlignment.Center
        topField.text = "-----------Top-----------"
        
        bottomField.defaultTextAttributes = memeTextAttributes
        bottomField.textAlignment = NSTextAlignment.Center
        bottomField.text = "-----------Bottom-----------"
       
        self.topField.delegate = self
        self.bottomField.delegate = self
        
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            self.cameraButton.enabled = true
        } else {
            self.cameraButton.enabled = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        
       self.subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
  
    
    func returnToViewController() {
 
        self.setInitialScreenSettings()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
    
        self.setInitialScreenSettings()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }

    
    @IBAction func pickAnImageCamera(sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){

            if let image =  info[UIImagePickerControllerOriginalImage] as? UIImage {

                self.navigationItem.leftBarButtonItem?.enabled = true
                self.navigationItem.rightBarButtonItem?.enabled = true
                bottomField.hidden = false
                topField.hidden = false
                self.imagePickerView.image = image
                self.dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        self.imagePickerView.image = nil
        self.topField.hidden = true
        self.bottomField.hidden = true
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
  
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField.text == "-----------Top-----------" {
            textField.text = ""
        }
        
        if textField.text == "-----------Bottom-----------" {
            textField.text = ""
        }
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // Do Nothing. N/A for Numpa
        textField.resignFirstResponder()
        //self.view.frame.origin.y = 0
        return true;
    }
 
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
  
    
    func keyboardWillShow(notification: NSNotification) {
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
  
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
   
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    func shareMeme() {
    
        memeImageTemp = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImageTemp], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)

        controller.completionWithItemsHandler = {(activityType, completed:Bool, NSArray returnedItems, NSError activityError) in
            
            
            self.save()
            self.dismissViewControllerAnimated(true, completion: nil)
            self.showTableView()
        }

// SAVE BELOW FOR FUTURE REFERENCE
//            if !completed {
//                println("cancelled")
//                return
//            }
//            if activityType == UIActivityTypePostToTwitter {
//                    println("twitter")
//            }
//        
//            if activityType == UIActivityTypeMail {
//                    println("mail")
//            }
    }

    
     func showTableView() {
        
        var controllerMeme: UITabBarController
        controllerMeme = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        self.navigationController!.pushViewController(controllerMeme, animated: true)
    }

    
    func save() {
        
        var meme = Meme( topText: topField.text!, bottomText: bottomField.text!, image:
            self.imagePickerView.image!, memeImage: memeImageTemp)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }

    
    func generateMemedImage() -> UIImage {

        // Render view to an image

        self.bottomTab.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.bottomTab.hidden = false
        
        return memedImage
    }
}

