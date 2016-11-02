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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        self.navigationController?.isNavigationBarHidden = false
        
        switch segue.identifier! {
            case "main_to_HAB_list":
                segue.destination.navigationItem.title = "HAB"
            case "main_to_photo_list":
                segue.destination.navigationItem.title = "Photo"
            default:
                return
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
}

