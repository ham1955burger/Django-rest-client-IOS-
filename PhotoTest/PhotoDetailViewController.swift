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
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
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
        self.uploadWithAlamofire()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension PhotoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageButton.setBackgroundImage(pickedImage, forState: .Normal)
            self.imageButton.setTitle("", forState: .Normal)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.imagePicker.delegate = self
    }
}

extension PhotoDetailViewController {
    // import Alamofire
    func uploadWithAlamofire() {
        
        // define parameters
        let parameters = [
            "description": self.bodyTextField.text!,
        ]
        
        // Begin upload
        Alamofire.upload(.POST, "http://127.0.0.1:8000/photo",
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
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                }
        })
    }
}
