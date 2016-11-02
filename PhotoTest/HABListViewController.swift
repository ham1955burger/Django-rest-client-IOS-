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
    @IBOutlet weak var totalLabel: UILabel!
    
    var list: [JSON]?
    
    override func viewDidLoad() {
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Alamofire.request("http://127.0.0.1:8000/list/", method: .get, parameters: nil, encoding: JSONEncoding.default)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    
                    let json = JSON(data)
                    self.list = json.arrayValue
                    print(self.list)
                    
                    //server에서 뿌려주는게 맞는거 같음
                    var totalPrice: Int = 0
                    for info in self.list! {
                        if info["state"].stringValue == "receive" {
                            totalPrice += info["price"].intValue
                        } else if info["state"].stringValue == "pay" {
                            totalPrice -= info["price"].intValue
                        }
                    }
                    
                    self.totalLabel.text = "total : \(totalPrice)원"
                    self.tableView.reloadData()
                    
                case .failure(let error):
                    print(error)
            }
        }
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        switch segue.identifier! {
//        case "hab_list_to_detail":
//            let vc = segue.destinationViewController as! DetailHABViewController
//            vc.viewType = .Add
//        default:
//            return
//        }
//    }
}

extension HABListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.list != nil else {
            return 0
        }
        
        if self.list!.count == 0 {
            self.tableView.isHidden = true
            self.emptyLabel.isHidden = false
            return 0
        } else {
            self.tableView.isHidden = false
            self.emptyLabel.isHidden = true
            return self.list!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCell") as! HABTableViewCell
        cell.fillCell(self.list![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.list![indexPath.row]
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let detailHABViewController: DetailHABViewController = storyboard.instantiateViewController(withIdentifier: "detailHABViewController") as! DetailHABViewController
        detailHABViewController.viewType = .edit
        detailHABViewController.info = info
        
        self.present(detailHABViewController, animated: true, completion: nil)
    }
}

class HABTableViewCell: UITableViewCell {
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var category_priceLabel: UILabel!
    @IBOutlet weak var memoLabel: UILabel!
    
    func fillCell(_ info: JSON) {
        self.stateLabel.text = info["state"].stringValue.stateHABString()
        self.category_priceLabel.text = "\(info["category"]) / \(info["price"].stringValue)"
        self.memoLabel.text = info["memo"].stringValue
    }
}
