//
//  ShopTableViewCell.swift
//  RANT
//
//  Created by Aligazy Kismetov on 04.05.2022.
//  Copyright © 2022 Ali. All rights reserved.
//

import UIKit
import SDWebImage

class ShopTableViewCell: UITableViewCell {

    @IBOutlet weak var imgLabel: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
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
        categoryLabel.text = product.categoryName
        priceLabel.text = String(product.price)
        descriptionLabel.text = product.description
        
        imgLabel.sd_setImage(with: URL(string: product.imgLink))
    }
}
