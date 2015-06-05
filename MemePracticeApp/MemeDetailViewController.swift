//
//  MemeDetailViewController.swift
//  MemePracticeApp
//
//  Created by Rod Paras on 5/30/15.
//  Copyright (c) 2015 Rodacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController, UINavigationControllerDelegate {

    var meme: Meme?
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        memeImageView.image =  meme?.memeImage
        tabBarController?.tabBar.hidden = true
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false

    }
}


//SAVE FOR FUTURE REFERENCE
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem (
//                    title: "Return",
//                    style: UIBarButtonItemStyle.Plain,
//                    target: self,
//                    action: "returnToViewController")
//
//      }
//
//    func returnToViewController() {
//
//        if let navigationController = self.navigationController {
//            navigationController.popToRootViewControllerAnimated(true)
//            //navigationController.popToViewController(MemeTableViewController, animated: true)
//        }
//
//    }
//
//    func startOver() {
//
//        var controllerMeme: UITabBarController
//
//        controllerMeme = self.storyboard?.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
//
//        self.navigationController!.pushViewController(controllerMeme, animated: true)
//
//
//    if let navigationController = self.navigationController {
//        //navigationController.popToRootViewControllerAnimated(true)
//        navigationController.popToViewController(MemeTableViewController, animated: true)
//        }
