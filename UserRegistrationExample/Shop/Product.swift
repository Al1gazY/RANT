//
//  Product.swift
//  UserRegistrationExample
//
//  Created by Aligazy Kismetov on 11.05.2022.
//  Copyright © 2022 Ali. All rights reserved.
//

import Foundation

class Product: Decodable {
    let name: String
    let id: Int
    let imgLink: String
    let description: String
    let categoryName: String
    let price: Int
}
