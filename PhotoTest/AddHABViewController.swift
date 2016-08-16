//
//  AddHABViewController.swift
//  PhotoTest
//
//  Created by ouniwang on 8/12/16.
//  Copyright © 2016 ouniwang. All rights reserved.
//

import UIKit

class AddHABViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func actionCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionAddButton(sender: AnyObject) {
        
        
        var parameters: [String: AnyObject] = ["": ""]
        if segmentedControl.selectedSegmentIndex == 0 {
            //receive
            parameters = ["date": self.dateTextField.text!, "price": self.priceTextField.text!, "state": "receive", "category": self.categoryTextField.text!, "memo": self.categoryTextField.text!]
        } else {
            //pay
            parameters = ["date": self.dateTextField.text!, "price": self.priceTextField.text!, "state": "pay", "category": self.categoryTextField.text!, "memo": self.categoryTextField.text!]
        }
        
        print(parameters)
        
        
        Alamofire.request(.POST, "http://127.0.0.1:8000/list", parameters: parameters, encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    print(data)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                case .Failure(let error):
                    print(error)
                    
                    let alert = UIAlertController.init(title: "", message: String(error), preferredStyle: .Alert)
                    let confirmButton = UIAlertAction.init(title: "확인", style: .Default, handler: nil)
                    
                    alert.addAction(confirmButton)
                    
                    self.presentViewController(alert, animated: true, completion: nil)
                }
        }

    }
}
