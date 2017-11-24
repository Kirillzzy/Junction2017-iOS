//
//  MainViewController.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 24/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
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
    tableView.register(UINib(nibName: "GoodTableViewCell", bundle: nil),
                          forCellReuseIdentifier: "GoodTableViewCell")
    tableView.sectionHeaderHeight = 50
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
