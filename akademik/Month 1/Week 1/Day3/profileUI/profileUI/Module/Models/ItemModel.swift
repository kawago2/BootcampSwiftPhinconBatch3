//
//  ItemModel.swift
//  profileUI
//
//  Created by Phincon on 02/11/23.
//

import Foundation
import UIKit

struct ItemModel : Codable, Hashable{
    var image: String?
    var name: String?
    var price: Int?
    var isFavorite: Bool?
}

