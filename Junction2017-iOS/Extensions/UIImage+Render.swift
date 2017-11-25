//
//  UIImage+Render.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 25/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit.UIImage

extension UIImage {
  var imageWithTemplateRendingMode: UIImage {
    return self.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
  }
}
