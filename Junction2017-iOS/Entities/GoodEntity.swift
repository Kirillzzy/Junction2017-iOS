//
//  GoodEntity.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 24/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit

struct GoodEntity {
  let id: Int
  let company: String

  enum StatusType {
    case delivered
    case undelivered

    var title: String {
      switch self {
      case .delivered:
        return "Delivered"
      case .undelivered:
        return "Undelivered"
      }
    }

    var titleColor: UIColor {
      switch self {
      case .delivered:
        return UIColor(hexString: "4DD964") // green
      case .undelivered:
        return UIColor(hexString: "969696") // gray
      }
    }
  }
  var status: StatusType
}
