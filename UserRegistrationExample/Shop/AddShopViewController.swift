//
//  AddShopViewController.swift
//  RANT
//
//  Created by Aligazy Kismetov on 04.05.2022.
//  Copyright © 2022 Ali. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper

class AddShopViewController: UIViewController {
    @IBOutlet weak var category: TextField!
    @IBOutlet weak var descriptionLabel: TextField!
    @IBOutlet weak var priceLabel: TextField!
    @IBOutlet weak var imageLabel: TextField!
    @IBOutlet weak var nameLabel: TextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addShop(_ sender: Any) {
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let name = nameLabel.text
        let price = priceLabel.text
        let image = imageLabel.text
        let des = descriptionLabel.text
        let cat = category.text
        
        // Check if required fields are not empty
        if (name?.isEmpty)! || (price?.isEmpty)! || (image?.isEmpty)! || (des?.isEmpty)! || (cat?.isEmpty)!
        {
            // Display alert message here
            displayMessage(userMessage: "One of the required fields is missing")
            
            return
        }
        

        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        
        // Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        // If needed, you can prevent Acivity Indicator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        // Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        
        //Send HTTP Request to perform Sign in
        let myUrl = URL(string: "https://sf-rant-backend.herokuapp.com/market/add")
        var request = URLRequest(url:myUrl!)
       
        request.httpMethod = "POST"// Compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
        
        let postString = ["name": name!, "imgLink": image!, "description": des!, "price": price!, "categoryName": cat!] as [String: String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong...")
            return
        }
        
         let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil
            {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                print("error=\(String(describing: error))")
                return
            }
            
            //Let's convert response sent from a server side code to a NSDictionary object:
             do {
                 let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                 if let parseJSON = json {
                     
                     self.displayMessage(userMessage: "Successfully Added")
                     
                 } else {
                     //Display an Alert dialog with a friendly error message
                     self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later")
                 }
             } catch {
                 
                 self.removeActivityIndicator(activityIndicator: myActivityIndicator)
                 
                 // Display an Alert dialog with a friendly error message
                 self.displayMessage(userMessage: "Error")
                 print(error)
             }
         }
        task.resume()
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
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        DispatchQueue.main.async
            {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
        }
    }
    
    @IBAction func back(_ sender: Any) {
        let vs = storyboard?.instantiateViewController(withIdentifier: "myTabBar") as! UITabBarController
        vs.modalPresentationStyle = .overFullScreen
        vs.selectedIndex = 2
        present(vs, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
