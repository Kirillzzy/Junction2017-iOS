//
//  TabBarItemView.swift
//  CHMeetupApp
//
//  Created by Alexander Zimin on 08/03/2017.
//  Copyright © 2017 CocoaHeads Community. All rights reserved.
//

import UIKit

class TabBarItemView: CustomTabBarItemView {

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!

  enum `Type` {
    case list
    case camera

    var icon: UIImage {
      var image: UIImage
      switch self {
      case .list:
        image = #imageLiteral(resourceName: "tab_list")
      case .camera:
        image = #imageLiteral(resourceName: "tab_camera")
      }
      return image.imageWithTemplateRendingMode
    }

    var title: String {
      switch self {
      case .list:
        return "List"
      case .camera:
        return "Camera"
      }
    }
  }

  enum State {
    case selected
    case unselected

    var color: UIColor {
      switch self {
      case .selected:
        return UIColor(hexString: "C70FEE")
      case .unselected:
        return UIColor(hexString: "8C8C8C")
      }
    }
  }

  private(set) var type: Type = .list {
    didSet {
      updateType()
    }
  }

  private(set) var state: State = .unselected {
    didSet {
      updateState()
    }
  }

  static func create(with type: Type) -> TabBarItemView {
    let cell = loadViewFromNib()
    cell.type = type
    return cell
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    state = selected ? .selected : .unselected
  }

  private func updateState() {
    imageView.tintColor = state.color
    titleLabel.textColor = state.color
  }

  private func updateType() {
    imageView.image = type.icon
    titleLabel.text = type.title
  }
}
