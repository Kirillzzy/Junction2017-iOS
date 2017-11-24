//
//  GoodTableViewCell.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 24/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit

class GoodTableViewCell: UITableViewCell {
  @IBOutlet private var idLabel: UILabel!
  @IBOutlet private var companyLabel: UILabel!
  @IBOutlet private var statusLabel: UILabel!
  @IBOutlet var mainView: UIView! {
    didSet {
      mainView.layer.masksToBounds = true
      mainView.layer.cornerRadius = 10
    }
  }
  func configure(with entity: GoodEntity) {
    idLabel.text = String(describing: entity.id)
    companyLabel.text = entity.company
    statusLabel.text = entity.status
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    selectionStyle = .none
  }
}
