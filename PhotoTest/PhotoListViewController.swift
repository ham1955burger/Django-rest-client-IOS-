//
//  PhotoListViewController.swift
//  PhotoTest
//
//  Created by ouniwang on 8/12/16.
//  Copyright © 2016 ouniwang. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var list: [JSON]?
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        Alamofire.request(.GET, "http://127.0.0.1:8000/photo")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    
                    let json = JSON(data)
                    self.list = json.arrayValue
                    print(self.list)
                    self.collectionView.reloadData()
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
}

extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.list != nil else {
            return 0
        }
        
        if self.list!.count == 0 {
            self.collectionView.hidden = true
            self.emptyLabel.hidden = false
            return 0
        }
        return self.list!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.fill(self.list![indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(UIScreen.mainScreen().bounds.width / 2 - 1.25, self.collectionView.frame.height / 3)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewlayout: UICollectionViewLayout, insetForSectionAtIndex section: NSInteger) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewlayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: NSInteger) -> CGFloat {
        return 2.0;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: NSInteger) -> CGFloat {
        return 2.0;
    }
}



class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func fill(info: JSON) {
//        self.imageView.image = info["image_thumb_file"]
        
        Alamofire.request(.GET, "http://127.0.0.1:8000/\(info["image_thumb_file"])").response { (request, response, data, error) in
            let image = UIImage(data: data!, scale: 1)
            self.imageView.image = UIImage(data: data!, scale: 0.8)
        }
        
        self.bodyLabel.text = info["description"].stringValue
    }
}