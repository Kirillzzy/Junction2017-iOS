//
//  ContractViewController.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 25/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit
import WebKit
import PromiseKit
import KRProgressHUD

enum CargoStatus: Int {
  case inactive, inDelivery, damaged, delivered, checked
}

class ContractViewController: UIViewController {
  @IBOutlet var mainLabel: UILabel!
  var managedWebView: WKWebView?
  var scannedQrString: String!
  var companyAddress: String!
  var workerAddress: String!
  var cargoId: Int!
  var cargoInfo: (name: String, company: String)!

  // Prevent getCargoStatus async execution
  var group = DispatchGroup()
  var statusInfo: Any?
  var newStatus: CargoStatus?

  // Hardcode
  let workers = ["0xe8e9e107037595ec64f032a57a354524911a349e", "0xea63073fbc90d8493812b0e59a85528e60b21711"]
  let places = [
    "Greece": 0,
    "Holland": 1,
    "Germany": 2,
    "Spain": 3
  ]
  let companies = [
    "Johnson & Johnson": "0x6a175cdcce90f7cf2dcbfc16257989f0d1d5f553",
    "Junction Flowers Inc.": "0x2ac5d7e4e2e23679de963c0cb098741a38221d1d"
  ]
  let cargos = [
    "Red Tulip": 0,
    "Pharmacy": 1
  ]
  
  @IBOutlet weak var graph: UIImageView!
  @IBAction func onDoneButtonClick(_ sender: Any) {
    AppDelegate.selectedBarIndex = 0
    UIApplication.shared.delegate?.window??.rootViewController
      = mainStoryboad.instantiateViewController(withIdentifier: "MainTabBarViewContoller")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    var parts = scannedQrString.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    // Workaround for wrong QR code :(
    if scannedQrString.starts(with: "Johnson & Johnson") {
      parts.swapAt(0, 1)
      parts[0] = parts[0].capitalized
    }

    cargoId = cargos[parts[0]]
    cargoInfo = (name: parts[0], company: parts[1])
    companyAddress = companies[parts[1]]
    workerAddress = workers[0]
    guard cargoId != nil, companyAddress != nil, workerAddress != nil else {
      print("invalid ids")
      return
    }

    managedWebView = WKWebView()
    guard let managedWebView = managedWebView else {
      print("Unable to init web view for web3")
      return
    }

    managedWebView.navigationDelegate = self
    view.addSubview(managedWebView)
    guard let htmlFile = Bundle.main.path(forResource: "web3", ofType: "html"),
      let html = try? String(contentsOfFile: htmlFile, encoding: String.Encoding.utf8) else {
      print("Unable to load web3 html file")
      return
    }

    managedWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    KRProgressHUD.set(style: .black).show()
  }

  private func succeed() {
    DispatchQueue.main.async { [unowned self] in
      KRProgressHUD.set(style: .black).showSuccess()
      switch self.newStatus ?? .inDelivery {
      case .delivered:
        self.mainLabel.text =
        """
        Cargo: \(self.cargoInfo.name)
        Company: \(self.cargoInfo.company)
        Status: Delivered
        """
        self.graph.isHidden = false
        self.graph.image = #imageLiteral(resourceName: "shaking2")
      default:
        self.mainLabel.text =
        """
        Cargo: \(self.cargoInfo.name)
        Company: \(self.cargoInfo.company)
        Status: In delivery
        """
        self.graph.isHidden = true
      }
//      DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
//        UIApplication.shared.delegate?.window??.rootViewController
//          = mainStoryboad.instantiateViewController(withIdentifier: "MainTabBarViewContoller")
//      })
    }
  }
}

extension ContractViewController: WKNavigationDelegate {
  func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    print("Error during navigation: \(error)")
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    webView.evaluateJavaScript("web3.isConnected()", completionHandler: { res, error in
      if let connected = res as? Int, connected == 1 {
        print("connected to ethereum node")
        self.getCargoInfo(id: self.cargoId).then { res -> Promise<Any?> in
          if let res = res as? NSDictionary,
            let someArray = res["c"] as? NSArray,
            let value = someArray[0] as? Int,
            let status = CargoStatus(rawValue: value) {
            switch status {
            case .inDelivery:
              self.newStatus = .delivered
              return self.makeCargoDelivered(company: self.companyAddress,
                                             worker: self.workerAddress,
                                             cargoId: self.cargoId)
            default:
              self.newStatus = .inDelivery
              return self.setCargoToDelivery(company: self.companyAddress,
                                             worker: self.workerAddress,
                                             cargoId: self.cargoId)
            }
          } else {
            throw NSError() // just jump to catch block
          }
        }.then { [weak self] res -> Void in
          self?.succeed()
          print("transaction: \(String(describing: res))")
        }.catch { error in
          print("error: \(error)")
        }
      } else {
        print("unable to connect to the node, error = \(error?.localizedDescription ?? "nil")")
      }
    })
  }
}

// MARK: - Contract interface
extension ContractViewController {
  typealias Address = String
  func makeCargoDelivered(company: Address, worker: Address, cargoId: Int) -> Promise<Any?> {
    return Promise { fulfill, reject in
      // swiftlint:disable:next line_length
      self.managedWebView?.evaluateJavaScript("TrackTruck.makeCargoDelivered(\"\(company)\", \"\(worker)\", \"\(cargoId)\")", completionHandler: { res, error in
        if let res = res {
          print("res: \(res)")
          fulfill(res)
        } else {
          print("error: \(error?.localizedDescription ?? "nil")")
          reject(error ?? NSError())
        }
      })
    }
  }

  func setCargoToDelivery(company: Address, worker: Address, cargoId: Int) -> Promise<Any?> {
    return Promise { fulfill, reject in
      // swiftlint:disable:next line_length
      self.managedWebView?.evaluateJavaScript("TrackTruck.setCargoToDelivery(\"\(company)\", \"\(worker)\", \"\(cargoId)\")", completionHandler: { res, error in
        if let res = res {
          print("res: \(res)")
          fulfill(res)
        } else {
          print("error: \(error?.localizedDescription ?? "nil")")
          reject(error ?? NSError())
        }
      })
    }
  }

  func setCargoToDamaged(company: Address, worker: Address, cargoId: Int) -> Promise<Any?> {
    return Promise { fulfill, reject in
      // swiftlint:disable:next line_length
      self.managedWebView?.evaluateJavaScript("TrackTruck.setCargoToDamaged(\"\(company)\", \"\(worker)\", \"\(cargoId)\")", completionHandler: { res, error in
        if let res = res {
          print("res: \(res)")
          fulfill(res)
        } else {
          print("error: \(error?.localizedDescription ?? "nil")")
          reject(error ?? NSError())
        }
      })
    }
  }

  func getCargoInfo(id: Int) -> Promise<Any?> {
    return Promise { fulfill, _ in
      self.managedWebView?.configuration.userContentController.add(self, name: "handler")
      self.statusInfo = nil
      self.group.enter()
      // swiftlint:disable:next line_length
      self.managedWebView?.evaluateJavaScript("TrackTruck.getCargoStatus.call(\(id), function(err, res) { window.webkit.messageHandlers[\"handler\"].postMessage(res); })", completionHandler: { _, _ in
      })
      group.notify(queue: .main) {
        fulfill(self.statusInfo)
      }
    }
  }
}

extension ContractViewController: WKScriptMessageHandler {
  func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
    statusInfo = message.body
    managedWebView?.configuration.userContentController.removeScriptMessageHandler(forName: "handler")
    group.leave()
  }
}
