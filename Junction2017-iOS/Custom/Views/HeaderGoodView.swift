//
//  HeaderGoodView.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 24/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit

class HeaderGoodView: UIView {
  @IBOutlet var idLabel: UILabel!
  @IBOutlet var companyLabel: UILabel!
  @IBOutlet var statusLabel: UILabel!
  @IBOutlet var mainView: UIView! {
    didSet {
      mainView.layer.masksToBounds = true
      mainView.layer.cornerRadius = 10
    }
  }
  // MARK: - For loading from Nib
  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return self.loadFromNibIfEmbeddedInDifferentNib()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
