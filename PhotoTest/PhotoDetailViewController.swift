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
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var createdLabel: UILabel!
    
    var imagePicker: UIImagePickerController!
    var image: UIImage?
    var viewType: ViewType = .Add
    var info: JSON?
    
    override func viewDidLoad() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        
        if self.viewType == .Add {
            //add
            self.imageButton.setTitle("사진 가져오기", forState: .Normal)
            self.doneButton.setTitle("등록", forState: .Normal)
        } else {
            //edit
            self.imageButton.setTitle("", forState: .Normal)
            self.imageButton.setBackgroundImage(self.image!, forState: .Normal)
            self.bodyTextField.text = self.info!["description"].stringValue
            
            let str = self.info!["created_at"].stringValue as NSString
//            str.substringWithRange(Range<String.Index>(start: str.startIndex.advancedBy(2), end: str.endIndex.advancedBy(-1))) //"llo, playgroun"
            self.createdLabel.text = str.substringWithRange(NSRange(location: 0, length: 10))
            self.createdLabel.hidden = false
            self.deleteButton.hidden = false
            self.doneButton.setTitle("수정", forState: .Normal)
        }
    }
    
    @IBAction func actionImageButton(sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        actionSheet.addAction(UIAlertAction(title: "카메라에서 가져오기", style: .Default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            } else {
                // not allow
                print("not allow camera!")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "라이브러리에서 가져오기", style: .Default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
                self.imagePicker.sourceType = .PhotoLibrary
                self.presentViewController(self.imagePicker, animated: true, completion: nil)
            } else {
                // not allow
                print("not allow library!")
               
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .Destructive, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func actionCloseButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func actionDoneButton(sender: AnyObject) {
        if self.viewType == .Add {
            self.uploadWithAlamofire("http://127.0.0.1:8000/photo", state: true)
        } else {
            //edit
            self.uploadWithAlamofire("http://127.0.0.1:8000/photo/detail/\(self.info!["pk"])", state: false)
        }
        
    }
    
    @IBAction func actionDeleteButton(sender: AnyObject) {
        Alamofire.request(.DELETE, "http://127.0.0.1:8000/photo/detail/\(self.info!["pk"])")
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

extension PhotoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageButton.setBackgroundImage(pickedImage, forState: .Normal)
            self.imageButton.setTitle("", forState: .Normal)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension PhotoDetailViewController {
    // import Alamofire
    func uploadWithAlamofire(url: String, state: Bool) {
        
        // define parameters
        let parameters = [
            "description": self.bodyTextField.text!,
        ]
        
        if state {
            //add
            // Begin upload
            Alamofire.upload(.POST, url,
                             multipartFormData: { multipartFormData in
                                
                                // import image to request
                                if let imageData = UIImageJPEGRepresentation(self.imageButton.currentBackgroundImage!, 0.8) {
                                    multipartFormData.appendBodyPart(data: imageData, name: "image_file", fileName: "myImage.png", mimeType: "image/png")
                                }
                                
                                // import parameters
                                for (key, value) in parameters {
                                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                                }
                }, // you can customise Threshold if you wish. This is the alamofire's default value
                encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        //                    upload.responseJSON { response in
                        //                        debugPrint(response)
                        //                    }
                        self.oneButtonAlert(String("사진 등록 완료!!")){ (UIAlertAction) in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
            })
        } else {
            //edit
            // Begin upload
            Alamofire.upload(.PUT, url,
                             multipartFormData: { multipartFormData in
                                
                                // import image to request
                                if let imageData = UIImageJPEGRepresentation(self.imageButton.currentBackgroundImage!, 0.8) {
                                    multipartFormData.appendBodyPart(data: imageData, name: "image_file", fileName: "myImage.png", mimeType: "image/png")
                                }
                                
                                // import parameters
                                for (key, value) in parameters {
                                    multipartFormData.appendBodyPart(data: value.dataUsingEncoding(NSUTF8StringEncoding)!, name: key)
                                }
                }, // you can customise Threshold if you wish. This is the alamofire's default value
                encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .Success(let upload, _, _):
                        //                    upload.responseJSON { response in
                        //                        debugPrint(response)
                        //                    }
                        self.oneButtonAlert(String("수정 완료!!")){ (UIAlertAction) in
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        
                    case .Failure(let encodingError):
                        print(encodingError)
                    }
            })
        }
        
        
    }
}
