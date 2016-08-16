//
//  DetailHABViewController.swift
//  PhotoTest
//
//  Created by ouniwang on 8/12/16.
//  Copyright © 2016 ouniwang. All rights reserved.
//

import UIKit

enum ViewType {
    case Add
    case Edit
}

class DetailHABViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var stateTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var viewType: ViewType = .Add
    var info: JSON?
    
    override func viewDidLoad() {
        if self.viewType == .Add {
            self.doneButton.setTitle("등록", forState: .Normal)
        } else if self.viewType == .Edit {
            if self.info!["state"] == "receive" {
                self.segmentedControl.selectedSegmentIndex = 0
                self.deleteButton.hidden = true
            } else if self.info!["state"] == "pay" {
                self.segmentedControl.selectedSegmentIndex = 1
            }

            self.dateTextField.text = self.info!["date"].stringValue
            self.priceTextField.text = self.info!["price"].stringValue
            self.categoryTextField.text = self.info!["category"].stringValue.categoryToString()
            self.memoTextField.text = self.info!["memo"].stringValue
            
            self.deleteButton.hidden = false
            self.doneButton.setTitle("수정", forState: .Normal)
        }
        
    }
    
    @IBAction func actionCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionDoneButton(sender: AnyObject) {
        var parameters: [String: AnyObject] = ["": ""]
        
        if segmentedControl.selectedSegmentIndex == 0 {
            //receive
            parameters = ["date": self.dateTextField.text!, "price": self.priceTextField.text!, "state": "receive", "category": self.categoryTextField.text!.stringToCategory(), "memo": self.memoTextField.text!]
        } else {
            //pay
            parameters = ["date": self.dateTextField.text!, "price": self.priceTextField.text!, "state": "pay", "category": self.categoryTextField.text!.stringToCategory(), "memo": self.memoTextField.text!]
        }
        
        if self.viewType == .Add {
            print(parameters)
            print(parameters)
            print(parameters)
            print(parameters)
            Alamofire.request(.POST, "http://127.0.0.1:8000/list/", parameters: parameters, encoding: .JSON)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .Success(let data):
                        print(data)
                        self.oneButtonAlert(String("등록되었습니다")){ (UIAlertAction) in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                    case .Failure(let error):
                        print(error)
                        self.oneButtonAlert(String(error))
                    }
            }
        } else if self.viewType == .Edit {
            Alamofire.request(.PUT, "http://127.0.0.1:8000/detail/\(self.info!["pk"])", parameters: parameters, encoding: .JSON)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .Success(let data):
                        print(data)
                        self.oneButtonAlert(String("수정되었습니다")){ (UIAlertAction) in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }

                    case .Failure(let error):
                        print(error)
                        self.oneButtonAlert(String(error))
                    }
            }
        }
    }
    
    @IBAction func actionDeleteButton(sender: AnyObject) {
        Alamofire.request(.DELETE, "http://127.0.0.1:8000/detail/\(self.info!["pk"])")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    print(data)
                    self.oneButtonAlert(String("삭제되었습니다")){ (UIAlertAction) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }
                    
                case .Failure(let error):
                    print(error)
                    self.oneButtonAlert(String(error))
                }
        }
    }
}


extension DetailHABViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 2 {
            //category TextField
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
            actionSheet.addAction(UIAlertAction(title: "월급", style: .Default, handler: { (UIAlertAction) in
                textField.text = "월급"
            }))
            actionSheet.addAction(UIAlertAction(title: "식비", style: .Default, handler: { (UIAlertAction) in
                textField.text = "식비"
            }))
            actionSheet.addAction(UIAlertAction(title: "기타", style: .Default, handler: { (UIAlertAction) in
                textField.text = "기타"
            }))
            actionSheet.addAction(UIAlertAction(title: "취소", style: .Destructive, handler: nil))
            
            self.presentViewController(actionSheet, animated: true, completion: nil)
            return false
        }
        return true
    }
}