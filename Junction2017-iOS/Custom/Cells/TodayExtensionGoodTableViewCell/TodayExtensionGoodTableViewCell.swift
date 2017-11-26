//
//  TodayExtensionGoodTableViewCell.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 25/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit

class TodayExtensionGoodTableViewCell: UITableViewCell {
  @IBOutlet var firstLabel: UILabel!
  @IBOutlet var secondLabel: UILabel!
  @IBOutlet var thirdLabel: UILabel! {
    didSet {
      thirdLabel.layer.masksToBounds = true
      thirdLabel.layer.cornerRadius = 5
    }
  }

  func configure(with entity: GoodEntity) {
    secondLabel.text = "№ " + String(describing: entity.id) // + "."
    firstLabel.text = entity.company
    thirdLabel.text = entity.status.title
    thirdLabel.textColor = .white
    thirdLabel.backgroundColor = entity.status.titleColor
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
}
