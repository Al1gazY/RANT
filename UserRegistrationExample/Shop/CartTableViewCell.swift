//
//  CartTableViewCell.swift
//  RANT
//
//  Created by Aligazy Kismetov on 12.05.2022.
//  Copyright © 2022 Ali. All rights reserved.
//

import UIKit
import SDWebImage
class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imgLabel: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(product: Product) {
        nameLabel.text = product.name
        priceLabel.text = String(product.price)
        
        imgLabel.sd_setImage(with: URL(string: product.imgLink))
    }

}
