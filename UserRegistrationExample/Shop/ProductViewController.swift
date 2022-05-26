//
//  ProductViewController.swift
//  UserRegistrationExample
//
//  Created by Aligazy Kismetov on 11.05.2022.
//  Copyright © 2022 Ali. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftKeychainWrapper

class ProductViewController: UIViewController {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var catLabel: UILabel!
    @IBOutlet weak var imgLabel: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    public var position: Int = 0
    public var product: Product? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = product?.name
        desLabel.text = product?.description
        catLabel.text = product?.categoryName
        priceLabel.text = String(product!.price)
        imgLabel.sd_setImage(with: URL(string: product!.imgLink))
       
        print(product!)
    }
    
    @IBAction func addToCart(_ sender: Any) {
        let accessToken: String? = KeychainWrapper.standard.string(forKey: "accessToken")
        let id: Int? = product!.id
        
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
        let myUrl = URL(string: "https://sf-rant-backend.herokuapp.com/market/\(id!)/add")
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
    
    init(product: Product, position: Int){
        
        self.product = product
        self.position = position
        super.init(nibName: nil, bundle: nil)
    }
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
    }
}
