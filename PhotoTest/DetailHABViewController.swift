//
//  DetailHABViewController.swift
//  PhotoTest
//
//  Created by ouniwang on 8/12/16.
//  Copyright © 2016 ouniwang. All rights reserved.
//

import UIKit

enum ViewType {
    case add
    case edit
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
    
    var viewType: ViewType = .add
    var info: JSON?
    
    override func viewDidLoad() {
        if self.viewType == .add {
            self.doneButton.setTitle("등록", for: UIControlState())
        } else if self.viewType == .edit {
            if self.info!["state"] == "receive" {
                self.segmentedControl.selectedSegmentIndex = 0
                self.deleteButton.isHidden = true
            } else if self.info!["state"] == "pay" {
                self.segmentedControl.selectedSegmentIndex = 1
            }

            self.dateTextField.text = self.info!["date"].stringValue
            self.priceTextField.text = self.info!["price"].stringValue
            self.categoryTextField.text = self.info!["category"].stringValue.categoryToString()
            self.memoTextField.text = self.info!["memo"].stringValue
            
            self.deleteButton.isHidden = false
            self.doneButton.setTitle("수정", for: UIControlState())
        }
        
    }
    
    @IBAction func actionCloseButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDoneButton(_ sender: AnyObject) {
        var parameters: [String: AnyObject] = ["": "" as AnyObject]
        
        if segmentedControl.selectedSegmentIndex == 0 {
            //receive
            parameters = ["date": self.dateTextField.text! as AnyObject, "price": self.priceTextField.text! as AnyObject, "state": "receive" as AnyObject, "category": self.categoryTextField.text!.stringToCategory() as AnyObject, "memo": self.memoTextField.text! as AnyObject]
        } else {
            //pay
            parameters = ["date": self.dateTextField.text! as AnyObject, "price": self.priceTextField.text! as AnyObject, "state": "pay" as AnyObject, "category": self.categoryTextField.text!.stringToCategory() as AnyObject, "memo": self.memoTextField.text! as AnyObject]
        }
        
        if self.viewType == .add {
            print(parameters)
            print(parameters)
            print(parameters)
            print(parameters)
            
            Alamofire.request("http://127.0.0.1:8000/list/", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success(let data):
                    print(data)
                    self.oneButtonAlert(String("등록되었습니다")){ (UIAlertAction) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    print(error)
                    self.oneButtonAlert(String(describing: error))
                }
            })
            
//            Alamofire.request(.POST, "http://127.0.0.1:8000/list/", parameters: parameters, encoding: .JSON)
//                .validate()
//                .responseJSON { response in
//                    switch response.result {
//                    case .Success(let data):
//                        print(data)
//                        self.oneButtonAlert(String("등록되었습니다")){ (UIAlertAction) in
//                            self.dismissViewControllerAnimated(true, completion: nil)
//                        }
//                        
//                    case .Failure(let error):
//                        print(error)
//                        self.oneButtonAlert(String(error))
//                    }
//            }
        } else if self.viewType == .edit {
            Alamofire.request("http://127.0.0.1:8000/detail/\(self.info!["pk"])", method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        print(data)
                        self.oneButtonAlert(String("수정되었습니다")){ (UIAlertAction) in
                            self.dismiss(animated: true, completion: nil)
                        }

                    case .failure(let error):
                        print(error)
                        self.oneButtonAlert(String(describing: error))
                    }
            }
        }
    }
    
    @IBAction func actionDeleteButton(_ sender: AnyObject) {
        
        Alamofire.request("http://127.0.0.1:8000/detail/\(self.info!["pk"])", method: .delete, parameters: nil, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    print(data)
                    self.oneButtonAlert(String("삭제되었습니다")){ (UIAlertAction) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                case .failure(let error):
                    print(error)
                    self.oneButtonAlert(String(describing: error))
                }
        }
    }
}


extension DetailHABViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.tag == 2 {
            //category TextField
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.addAction(UIAlertAction(title: "월급", style: .default, handler: { (UIAlertAction) in
                textField.text = "월급"
            }))
            actionSheet.addAction(UIAlertAction(title: "식비", style: .default, handler: { (UIAlertAction) in
                textField.text = "식비"
            }))
            actionSheet.addAction(UIAlertAction(title: "기타", style: .default, handler: { (UIAlertAction) in
                textField.text = "기타"
            }))
            actionSheet.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
            
            self.present(actionSheet, animated: true, completion: nil)
            return false
        }
        return true
    }
}
