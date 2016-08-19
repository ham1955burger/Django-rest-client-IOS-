//
//  MainViewController.swift
//  PhotoTest
//
//  Created by ouniwang on 8/12/16.
//  Copyright © 2016 ouniwang. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        self.navigationController?.navigationBarHidden = false
        
        switch segue.identifier! {
            case "main_to_HAB_list":
                segue.destinationViewController.navigationItem.title = "HAB"
            case "main_to_photo_list":
                segue.destinationViewController.navigationItem.title = "Photo"
            default:
                return
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
}

