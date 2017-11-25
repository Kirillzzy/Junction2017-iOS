//
//  NavigationViewController.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 25/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationBar.setBackgroundImage(UIImage(), for: .default)

    navigationBar.barTintColor = .white
    navigationBar.isTranslucent = false
  }

  override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    viewControllers.last?.makeBackButtonEmpty()
    super.pushViewController(viewController, animated: animated)
  }
}
