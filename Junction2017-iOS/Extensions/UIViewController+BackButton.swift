//
//  UIViewController+BackButton.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 25/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit.UIViewController

extension UIViewController {
  func makeBackButtonEmpty() {
    navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
}
