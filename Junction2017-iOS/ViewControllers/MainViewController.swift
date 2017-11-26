//
//  MainViewController.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 24/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit

var goodEntities: [GoodEntity] {
  var goods = [GoodEntity]()
  goods.append(GoodEntity(id: 153624, company: "Johnson & Johnson", status: .delivered))
  goods.append(GoodEntity(id: 192390, company: "Junction Flowers Inc", status: .undelivered))
  goods.append(GoodEntity(id: 123945, company: "Junction Flowers Inc", status: .undelivered))
  goods.append(GoodEntity(id: 873268, company: "Apple Inc", status: .delivered))
  goods.append(GoodEntity(id: 120392, company: "Johnson & Johnson", status: .undelivered))
  goods.append(GoodEntity(id: 234899, company: "Ferrari", status: .delivered))
  goods.append(GoodEntity(id: 937928, company: "Junction Flowers Inc", status: .delivered))
  goods.append(GoodEntity(id: 348959, company: "Johnson & Johnson", status: .undelivered))
  return goods
}

class MainViewController: UIViewController {
  @IBOutlet var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.register(UINib(nibName: "GoodTableViewCell", bundle: nil),
                       forCellReuseIdentifier: "GoodTableViewCell")
    tableView.sectionHeaderHeight = 50
  }

  override func customTabBarItemContentView() -> CustomTabBarItemView {
    return TabBarItemView.create(with: .list)
  }
}

// MARK: - TableViewDelegate & TableViewDataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return goodEntities.count
  }

//  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let view = Bundle.main.loadNibNamed("HeaderGoodView", owner: self,
//                                        options: nil)?.first as! HeaderGoodView
//    
//    return view
//  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //swiftlint:disable:next force_cast
    let cell = tableView.dequeueReusableCell(withIdentifier: "GoodTableViewCell") as! GoodTableViewCell
    cell.configure(with: goodEntities[indexPath.row])
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
