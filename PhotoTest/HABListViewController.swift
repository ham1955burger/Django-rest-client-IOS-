//
//  HABListViewController.swift
//  PhotoTest
//
//  Created by ouniwang on 8/12/16.
//  Copyright © 2016 ouniwang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HABListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var list: [JSON]?
    
    override func viewDidLoad() {
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(animated: Bool) {
        Alamofire.request(.GET, "http://127.0.0.1:8000/list")
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let data):
                    
                    let json = JSON(data)
                    self.list = json.arrayValue
                    print(self.list)
                    self.tableView.reloadData()
                    
                case .Failure(let error):
                    print(error)
                }
        }
    }
}

extension HABListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.list != nil else {
            return 0
        }
        
        if self.list!.count == 0 {
            self.tableView.hidden = true
            self.emptyLabel.hidden = false
            return 0
        } else {
            return self.list!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell") as! HABTableViewCell
        cell.fillCell(self.list![indexPath.row])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let info = self.list![indexPath.row]
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailHABViewController: DetailHABViewController = storyboard.instantiateViewControllerWithIdentifier("detailHABViewController") as! DetailHABViewController
        detailHABViewController.viewType = .Edit
        detailHABViewController.info = info
        
        self.presentViewController(detailHABViewController, animated: true, completion: nil)
    }
}

class HABTableViewCell: UITableViewCell {
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var category_priceLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    func fillCell(info: JSON) {
        self.stateLabel.text = info["state"].stringValue.stateHABString()
        self.category_priceLabel.text = "\(info["category"]) / \(info["price"].stringValue)"
        self.memoLabel.text = info["memo"].stringValue
    }
}
