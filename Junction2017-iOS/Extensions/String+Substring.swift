//
//  String+Substring.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 25/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import Foundation

extension String {
  func substring(from index: Int) -> String {
    return String(self[self.index(startIndex, offsetBy: index)...])
  }

  func substring(with range: Range<Int>) -> String {
    let startIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
    let endIndex = self.index(self.startIndex, offsetBy: range.upperBound)
    return String(self[startIndex..<endIndex])
  }
}
