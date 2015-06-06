//
//  CustomUITabBarController.swift
//  MemePracticeApp
//
//  Created by Rod Paras on 6/2/15.
//  Copyright (c) 2015 Rodacity. All rights reserved.
//

import UIKit

class CustomUITabBarController: UITabBarController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .Add,
            target: self,
            action: "returnToViewController")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem (
            title: "Return",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "returnToSentMemes")
    }
    
    
    func returnToViewController() {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MainViewController") as! ViewController
        navigationController!.pushViewController(detailController, animated: true)
    }
    
    func returnToSentMemes() {
        
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        navigationController!.pushViewController(detailController, animated: true)

    }

}

//KEEP AROUND FOR EASY REFERENCE
//        if let navigationController = self.navigationController {
//                navigationController.popToRootViewControllerAnimated(true)
//                //navigationController.popToViewController(MemeTableViewController, animated: true)
//        }
