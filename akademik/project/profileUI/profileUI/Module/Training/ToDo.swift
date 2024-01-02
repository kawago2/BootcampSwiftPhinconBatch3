//
//  ToDo.swift
//  profileUI
//
//  Created by Phincon on 07/11/23.
//

import Foundation
import UIKit

struct ToDo: Codable {
  let userId: Int
  let id: Int
  let title: String
  let isComplete: Bool
  
  enum CodingKeys: String, CodingKey {
    case isComplete = "completed"
    case userId, id, title
  }
}


