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
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        return cell
    }
}



class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func fill(info: JSON) {
    
    }
}