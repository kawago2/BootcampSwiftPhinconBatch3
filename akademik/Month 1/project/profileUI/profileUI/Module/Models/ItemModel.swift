//
//  ItemModel.swift
//  profileUI
//
//  Created by Phincon on 02/11/23.
//

import Foundation
import UIKit

struct ItemModel : Codable, Hashable, Identifiable {
    var id = UUID()
    var image: String?
    var name: String?
    var price: Float?
    var isFavorite: Bool?
    var quantity:Int = 1
}

