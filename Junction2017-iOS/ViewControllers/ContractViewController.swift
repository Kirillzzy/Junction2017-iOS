//
//  ContractViewController.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 25/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit

class ContractViewController: UIViewController {
  @IBOutlet var mainLabel: UILabel!
  var scannedQrString: String!

  override func viewDidLoad() {
    super.viewDidLoad()
    mainLabel.text = scannedQrString
  }
}
