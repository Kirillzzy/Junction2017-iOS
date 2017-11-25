//
//  ContractViewController.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 25/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit
import WebKit

class ContractViewController: UIViewController {
  @IBOutlet var mainLabel: UILabel!
  
  var managedWebView: WKWebView?
  var scannedQrString: String!

  override func viewDidLoad() {
    super.viewDidLoad()
    mainLabel.text = scannedQrString
    
    managedWebView = WKWebView()
    guard let managedWebView = managedWebView else {
      print("unable to init web view for web3")
      return
    }
    
    managedWebView.navigationDelegate = self
    view.addSubview(managedWebView)
    
    guard let htmlFile = Bundle.main.path(forResource: "web3", ofType: "html"),
      let html = try? String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8) else {
      print("unable to load web3 html file")
      return
    }
    managedWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
  }
}

extension ContractViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    print("error during navigation: \(error)")
  }
  
  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    print("completed")
  }
}
