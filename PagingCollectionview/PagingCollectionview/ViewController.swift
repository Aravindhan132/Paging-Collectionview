//
//  ViewController.swift
//  PagingCollectionview
//
//  Created by aravind-pt2199 on 28/08/18.
//  Copyright © 2018 aravind-pt2199. All rights reserved.
//

import UIKit

struct jsonvalue {
    let name: String
    let developer: String?
     let typing: [String]?
    let os: [String]?
    let license: String
    let websiteURL: URL?
    init?(json: [String: Any]) {
        
        guard
            let name = json["name"] as? String,
             let license = json["license"] as? String
            else {
                
                return nil
        }
        self.name = name
         self.license = license
         self.developer = json["developer"] as? String
        self.typing = json["typing"] as? [String]
        self.os = json["OS"] as? [String]
        self.websiteURL = URL(string:json["website"] as? String ?? "")
    }
}
class ViewController: UIViewController {
    
    
    var dataList = NSMutableArray()
    var loadNumber = 0
    var newFetchBool = 0
   

    @IBOutlet weak var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
         self.view.backgroundColor = UIColor.gray
        fetchDataFromServer()
    }
  
    
    func fetchDataFromServer() {
        loadNumber += 1
        let urlStr = String(format: "https://jsonplaceholder.typicode.com/posts/\(loadNumber)/comments")
        guard let url2 = URL(string: urlStr) else {return}
        let task = URLSession.shared.dataTask(with: url2) { (data, reponse, error) in
            if(data != nil) {
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options:.mutableContainers) as! NSMutableArray
                    print(jsonData)
                    for item in jsonData {
                            self.dataList.add(item)
                    }
                    
                    DispatchQueue.main.async(execute: {
                        self.tableview.reloadData()
                    })
                }
                catch {
                    print("Error to parse the data")
                }
            }
            else {
                print("Data is Empty")
            }
        }
        task.resume()
    }
    func disable (id : Int , system : String , mail : String)
    {
        
    }
    func calculate(id : Int , name : String  , address : String )
    {
        if( id > 121 ) {
            print("Adress will be greate than 121")
        }
        else if (id>100 && id < 121) {
            print("Address will be between the 100 to 121")
        }
    }
}

extension ViewController : UITableViewDelegate , UITableViewDataSource , UIScrollViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : UITableViewCell!
        if((indexPath as NSIndexPath).row < dataList.count) {
            
            cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier")
            if (cell == nil) {
                cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "CellIdentifier")
             }
            cell.textLabel?.text = (dataList[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "email") as? String
            cell.backgroundColor = UIColor.darkGray
            return cell!
        }
        else {
            let refreshCell = tableView.dequeueReusableCell(withIdentifier: "RefreshCellIdentifier") as! RefreshCellView
            refreshCell.startStopLoading(false)
            return refreshCell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        newFetchBool = 0
        
     }
   
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath){
       newFetchBool += 1
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool){
        if(decelerate && newFetchBool >= 2 && scrollView.contentOffset.y >= 0) {
            let lastCellIndexPath = IndexPath(row:dataList.count , section: 0)
            let refreshCell = tableview.cellForRow(at: lastCellIndexPath) as! RefreshCellView
            refreshCell.startStopLoading(true)
            self.fetchDataFromServer()
            newFetchBool = 0
            CATransaction.commit()

        }
    }
}
