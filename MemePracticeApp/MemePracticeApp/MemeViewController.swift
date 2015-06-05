//
//  MemeViewController.swift
//  MemePracticeApp
//
//  Created by Rod Paras on 5/23/15.
//  Copyright (c) 2015 Rodacity. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    var memeImage: UIImage?
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    @IBOutlet weak var shareButton: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memeImageView.image = memeImage
        
    }
    func save() {
        
    }
    @IBAction func share(sender: UIBarButtonItem) {
        
        let image = memeImage!
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.presentViewController(controller, animated: true, completion: nil)
        
//        controller.completionWithItemsHandler = {
// 
//            self.save()
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }()

        }
    }
    
    
    @IBAction func Cancel(sender: UIBarButtonItem) {
        
                if let navigationController = self.navigationController {
                    println("here!")
                    navigationController.popToRootViewControllerAnimated(true)
        
        }

    }
}
