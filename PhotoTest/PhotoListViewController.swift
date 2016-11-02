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
    
    override func viewDidAppear(_ animated: Bool) {
        Alamofire.request("http://127.0.0.1:8000/photo", method: .get, parameters: nil, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    
                    let json = JSON(data)
                    self.list = json.arrayValue
                    print(self.list)
                    self.collectionView.reloadData()
                    
                case .failure(let error):
                    print(error)
                }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        switch segue.identifier! {
//        case "photo_list_to_detail":
//            let vc = segue.destinationViewController as! PhotoDetailViewController
//            vc.viewType = .Add
//        default:
//            return
//        }
//    }
}

extension PhotoListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.list != nil else {
            return 0
        }
        
        if self.list!.count == 0 {
            self.collectionView.isHidden = true
            self.emptyLabel.isHidden = false
            return 0
        }
        return self.list!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        cell.fill(self.list![indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width / 2 - 1.25, height: self.collectionView.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewlayout: UICollectionViewLayout, insetForSectionAtIndex section: NSInteger) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewlayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: NSInteger) -> CGFloat {
        return 2.0;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: NSInteger) -> CGFloat {
        return 2.0;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info = self.list![indexPath.row]
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let photoDetailViewController: PhotoDetailViewController = storyboard.instantiateViewController(withIdentifier: "photoDetailViewController") as! PhotoDetailViewController
        photoDetailViewController.viewType = .edit
        photoDetailViewController.info = info
        
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        photoDetailViewController.image = cell.imageView.image
        
        self.present(photoDetailViewController, animated: true, completion: nil)
    }
}


class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    func fill(_ info: JSON) {
        Alamofire.request("http://127.0.0.1:8000\(info["image_thumb_file"])").response { (response) in
            self.imageView.image = UIImage(data: response.data!, scale: 1)
            self.imageView.frame = self.bounds

        }
    }
}
