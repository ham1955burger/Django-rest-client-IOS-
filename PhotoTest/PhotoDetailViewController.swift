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
    var viewType: ViewType = .add
    var info: JSON?
    
    override func viewDidLoad() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        
        if self.viewType == .add {
            //add
            self.imageButton.setTitle("사진 가져오기", for: UIControlState())
            self.doneButton.setTitle("등록", for: UIControlState())
        } else {
            //edit
            self.imageButton.setTitle("", for: UIControlState())
            self.imageButton.setBackgroundImage(self.image!, for: UIControlState())
            self.bodyTextField.text = self.info!["description"].stringValue
            
            let str = self.info!["created_at"].stringValue as NSString
//            str.substringWithRange(Range<String.Index>(start: str.startIndex.advancedBy(2), end: str.endIndex.advancedBy(-1))) //"llo, playgroun"
            self.createdLabel.text = str.substring(with: NSRange(location: 0, length: 10))
            self.createdLabel.isHidden = false
            self.deleteButton.isHidden = false
            self.doneButton.setTitle("수정", for: UIControlState())
        }
    }
    
    @IBAction func actionImageButton(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "카메라에서 가져오기", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                // not allow
                print("not allow camera!")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "라이브러리에서 가져오기", style: .default, handler: { (UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            } else {
                // not allow
                print("not allow library!")
               
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "취소", style: .destructive, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func actionCloseButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionDoneButton(_ sender: AnyObject) {
        if self.viewType == .add {
            self.uploadWithAlamofire("http://127.0.0.1:8000/photo", state: true)
        } else {
            //edit
            self.uploadWithAlamofire("http://127.0.0.1:8000/photo/detail/\(self.info!["pk"])", state: false)
        }
        
    }
    
    @IBAction func actionDeleteButton(_ sender: AnyObject) {
        Alamofire.request("http://127.0.0.1:8000/photo/detail/\(self.info!["pk"])", method: .delete, parameters: nil, encoding: JSONEncoding.default)
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

extension PhotoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageButton.setBackgroundImage(pickedImage, for: UIControlState())
            self.imageButton.setTitle("", for: UIControlState())
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PhotoDetailViewController {
    // import Alamofire
    func uploadWithAlamofire(_ url: String, state: Bool) {
        
        // define parameters
        let parameters = [
            "description": self.bodyTextField.text!,
        ]
        
        if state {
            //add
            // Begin upload
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                // import image to request
                if let imageData = UIImageJPEGRepresentation(self.imageButton.currentBackgroundImage!, 0.8) {
                    multipartFormData.append(imageData, withName: "image_file", fileName: "myImage.png", mimeType: "image/png")
                }
                
                // import parameters
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }

            }, to: url, encodingCompletion: { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    //                    upload.responseJSON { response in
                    //                        debugPrint(response)
                    //                    }
                    self.oneButtonAlert(String("사진 등록 완료!!")){ (UIAlertAction) in
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                case .failure(let encodingError):
                    print(encodingError)
                }
            })
        } else {
            //edit
            // Begin upload
            
            if self.image != self.imageButton.currentBackgroundImage {
                //changed image
                
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    // import image to request
                    if let imageData = UIImageJPEGRepresentation(self.imageButton.currentBackgroundImage!, 0.8) {
                        multipartFormData.append(imageData, withName: "image_file", fileName: "myImage.png", mimeType: "image/png")
                    }
                    
                    // import parameters
                    for (key, value) in parameters {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    }
                    
                    }, to: url, encodingCompletion: { (encodingResult) in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            //                    upload.responseJSON { response in
                            //                        debugPrint(response)
                            //                    }
                            self.oneButtonAlert(String("수정 완료!!")){ (UIAlertAction) in
                                self.dismiss(animated: true, completion: nil)
                            }
                            
                        case .failure(let encodingError):
                            print(encodingError)
                        }
                })
            } else {
                //not changed image
                Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseJSON { response in
                    switch response.result {
                        case .success(let data):
                            self.oneButtonAlert(String("수정 완료!!")){ (UIAlertAction) in
                                self.dismiss(animated: true, completion: nil)
                            }
                        case .failure(let error):
                            print(error)
                    }
                }
            }
        }
    }
}
