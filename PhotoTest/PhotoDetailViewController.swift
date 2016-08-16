//
//  PhotoDetailViewController.swift
//  PhotoTest
//
//  Created by ouniwang on 8/16/16.
//  Copyright © 2016 ouniwang. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var bodyTextField: UITextField!
    
    override func viewDidLoad() {
    }
    
    @IBAction func actionCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
