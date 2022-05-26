//
//  ShopViewController.swift
//  UserRegistrationExample
//
//  Created by Aligazy Kismetov on 11.05.2022.
//  Copyright © 2022 Ali. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class ShopViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var list = [Product]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refresh()
    }
    
    func refresh(){
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        
        //Send HTTP Request to perform Sign in
        let myUrl = URL(string: "https://sf-rant-backend.herokuapp.com/market/getAll")
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "GET"// Compose a query string
        request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        

        let task = URLSession.shared.dataTask(with: request) { (data1: Data?, response: URLResponse?, error: Error?) in
            if let dataString = String(data: data1!, encoding: .utf8) {
                //print(dataString)
                
                do {
                    self.list = try JSONDecoder().decode([Product].self, from: Data(dataString.utf8))
                
                    print(self.list)
                    DispatchQueue.main.async {
                                        self.tableView.reloadData()
                                    }
                } catch let jsonArray {
                    print("JSON ERROR")
                }
            }
        }
        task.resume()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return list.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopTableViewCell
        // Configure the cell...
        cell.setData(product: list[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let viewController = storyboard?.instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
            viewController.product = list[indexPath.row]
            navigationController?.show(viewController, sender: self)
        present(viewController, animated: true)
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped")
                    
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
    
    @IBAction func addNew(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vs = storyboard.instantiateViewController(withIdentifier: "AddShopViewController")
        vs.modalPresentationStyle = .overFullScreen
        present(vs, animated: true)
    }
}
