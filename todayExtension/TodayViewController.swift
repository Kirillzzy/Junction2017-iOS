//
//  TodayViewController.swift
//  todayExtension
//
//  Created by Kirill Averyanov on 25/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  @IBOutlet var tableView: UITableView!
  var displayMode: NCWidgetDisplayMode!
  var goodEntities: [GoodEntity] {
    var goods = [GoodEntity]()
    goods.append(GoodEntity(id: 0, company: "MAZA RUSSIA", status: "Great"))
    goods.append(GoodEntity(id: 1, company: "Finland", status: "Bad"))
    goods.append(GoodEntity(id: 2, company: "Big Good", status: "Suspended"))
    goods.append(GoodEntity(id: 3, company: "Like a Boss", status: "Great"))
    goods.append(GoodEntity(id: 4, company: "MAZA RUSSIA", status: "Great"))
    goods.append(GoodEntity(id: 5, company: "Finland", status: "Bad"))
    goods.append(GoodEntity(id: 6, company: "Big Good", status: "Suspended"))
    goods.append(GoodEntity(id: 7, company: "Like a Boss", status: "Great"))
    return goods
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    tableView.register(UINib(nibName: "TodayExtensionGoodTableViewCell", bundle: nil),
                       forCellReuseIdentifier: "TodayExtensionGoodTableViewCell")
  }

  func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
    // Perform any setup necessary in order to update the view.

    // If an error is encountered, use NCUpdateResult.Failed
    // If there's no update required, use NCUpdateResult.NoData
    // If there's an update, use NCUpdateResult.NewData
    tableView.reloadData()
    completionHandler(NCUpdateResult.newData)
  }

  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode,
                                        withMaximumSize maxSize: CGSize) {
    displayMode = activeDisplayMode
    if activeDisplayMode == .compact {
      self.preferredContentSize = maxSize
    } else {
      self.preferredContentSize = CGSize(width: maxSize.width, height: CGFloat(37 * goodEntities.count))
    }
  }

}

// MARK: - TableViewDelegate & TableViewDataSource
extension TodayViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return goodEntities.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TodayExtensionGoodTableViewCell")
      as! TodayExtensionGoodTableViewCell //swiftlint:disable:this force_cast
    cell.configure(with: goodEntities[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
