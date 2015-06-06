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
    
    let bottomFieldDelegate = BottomFieldDelegate()
    
    var memeImageTemp: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
            setInitialScreenSettings()
    }

    func setInitialScreenSettings() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "Sent Memes",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "showTableView")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Action,
            target: self,
            action: "shareMeme")
        
        topField.hidden = true
        bottomField.hidden = true
        navigationItem.leftBarButtonItem?.enabled = false
        navigationItem.rightBarButtonItem?.enabled = true
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.redColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 30)!,
            NSStrokeWidthAttributeName : 4.0
        ]
        
        topField.delegate = self
        bottomField.delegate = bottomFieldDelegate

        topField.defaultTextAttributes = memeTextAttributes
        topField.textAlignment = NSTextAlignment.Center
        topField.text = "-----------Top-----------"
        
        bottomField.defaultTextAttributes = memeTextAttributes
        bottomField.textAlignment = NSTextAlignment.Center
        bottomField.text = "-----------Bottom-----------"
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        {
            cameraButton.enabled = true
        } else {
            cameraButton.enabled = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
         super.viewWillAppear(animated)
        
       subscribeToKeyboardNotifications()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
  
    
    func returnToViewController() {
 
        setInitialScreenSettings()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImage(sender: UIBarButtonItem) {
    
        setInitialScreenSettings()
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }

    
    @IBAction func pickAnImageCamera(sender: UIBarButtonItem) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){

            if let image =  info[UIImagePickerControllerOriginalImage] as? UIImage {

                navigationItem.leftBarButtonItem?.enabled = true
                navigationItem.rightBarButtonItem?.enabled = true
                bottomField.hidden = false
                topField.hidden = false
                imagePickerView.image = image
                dismissViewControllerAnimated(true, completion: nil)
            }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        imagePickerView.image = nil
        topField.hidden = true
        bottomField.hidden = true
        navigationItem.leftBarButtonItem?.enabled = false
        navigationItem.rightBarButtonItem?.enabled = false
        dismissViewControllerAnimated(true, completion: nil)
        
    }
  
    
  
    //This ViewController is topFieldDelegate. bottomeField uses BottomField Delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {

        unsubscribeFromKeyboardNotifications()
        return true
    }
    

    func textFieldDidBeginEditing(textField: UITextField) {

        if textField.text == "-----------Top-----------" {
            textField.text = ""
        }
    }

    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        subscribeToKeyboardNotifications()
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
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
  
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
   
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    
    func shareMeme() {
    
        memeImageTemp = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImageTemp], applicationActivities: nil)
        presentViewController(controller, animated: true, completion: nil)

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
        navigationController!.pushViewController(controllerMeme, animated: true)
    }

    
    func save() {
        
        var meme = Meme( topText: topField.text!, bottomText: bottomField.text!, image:
            self.imagePickerView.image!, memeImage: memeImageTemp)
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
    }

    
    func generateMemedImage() -> UIImage {

        // Render view to an image

        bottomTab.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        bottomTab.hidden = false
        
        return memedImage
    }
}

