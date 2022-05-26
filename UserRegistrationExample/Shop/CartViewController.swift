//
//  CartViewController.swift
//  RANT
//
//  Created by Aligazy Kismetov on 12.05.2022.
//  Copyright © 2022 Ali. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

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
        let myUrl = URL(string: "https://sf-rant-backend.herokuapp.com/market/cart")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CartTableViewCell
        // Configure the cell...
        cell.setData(product: list[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 123.0
    }
    
    @IBAction func buyCart(_ sender: Any) {
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        
        // Send HTTP Request to Register user
        let myUrl = URL(string: "https://sf-rant-backend.herokuapp.com/market/cart/buy")
                var request = URLRequest(url:myUrl!)
                request.httpMethod = "POST"// Compose a query string
                request.addValue("application/json", forHTTPHeaderField: "content-type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
     let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
        self.removeActivityIndicator(activityIndicator: myActivityIndicator)
        
        if error != nil
        {
            self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
            print("error=\(String(describing: error))")
            return
        }
       
         self.displayMessage(userMessage: "Adding done")
        }
        
        task.resume()
        refresh()
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView)
      {
          DispatchQueue.main.async
           {
                  activityIndicator.stopAnimating()
                  activityIndicator.removeFromSuperview()
          }
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
    
}
