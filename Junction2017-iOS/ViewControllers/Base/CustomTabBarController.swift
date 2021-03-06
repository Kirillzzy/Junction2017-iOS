//
//  CustomTabBarController.swift
//  Junction2017-iOS
//
//  Created by Kirill Averyanov on 25/11/2017.
//  Copyright © 2017 Kirill Averyanov. All rights reserved.
//

// Inside one file because of fileprivate
// By Alexander Zimin (github.com/azimin)

import UIKit

private let defaultHeight: CGFloat = 54

open class CustomTabBarItemView: UIView {
  public var heightValue: CGFloat?
  var preferedHeight: CGFloat {
    return heightValue ?? _preferedHeight
  }

  fileprivate var _preferedHeight: CGFloat = defaultHeight
  fileprivate weak var heightConstraint: NSLayoutConstraint!

  fileprivate(set) var index: Int = 0

  private var _isSelected: Bool = false
  public var isSelected: Bool {
    return _isSelected
  }

  /// DON'T CALL IT MANUALLY, JUST FOR OVERRIDING
  open func setSelected(_ selected: Bool, animated: Bool) {
    _isSelected = selected
  }

  public static func loadViewFromNib() -> Self {
    return self.init().loadFromNibIfEmbeddedInDifferentNib()
  }

  open var accessibilityTitle: String {
    var title = ""
    for view in subviews {
      if let label = view as? UILabel,
        let text = label.text {
        title += "\(text)\n"
      }
    }
    return title
  }

  // MARK: - Accessibility

  open override var accessibilityLabel: String? {
    get {
      if let value = super.accessibilityLabel,
        value.count > 0 {
        return value
      }
      return accessibilityTitle
    }
    set {
      super.accessibilityLabel = accessibilityLabel
    }
  }

  open override var isAccessibilityElement: Bool {
    get {
      return true
    }
    set {
      super.isAccessibilityElement = newValue
    }
  }

  open override var accessibilityTraits: UIAccessibilityTraits {
    set {
      super.accessibilityTraits = accessibilityTraits
    }
    get {
      let value = super.accessibilityTraits
      return value | UIAccessibilityTraitButton | (UIAccessibilityTraitSelected * (isSelected ? 1 : 0))
    }
  }

}

public class CustomTabBarItem: UITabBarItem {
  fileprivate var containerView: CustomTabBarItemView!

  public var index: Int {
    return containerView.index
  }

  public var isSelected: Bool {
    return containerView.isSelected
  }

  fileprivate func setSelected(_ selected: Bool, animated: Bool) {
    containerView.setSelected(selected, animated: animated)
  }
}

public class CustomTabBar: UITabBar {
  fileprivate var preferedHeight: CGFloat = defaultHeight
  fileprivate weak var customTabBarController: CustomTabBarController?

  // MARK: - Override default methods

  public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    for item in customTabBarController?.customItems ?? [] {
      if item.containerView.frame.contains(point) {
        return true
      }
    }
    return super.point(inside: point, with: event)
  }

  public override func sizeThatFits(_ size: CGSize) -> CGSize {
    var size = super.sizeThatFits(size)
    size.height = preferedHeight
    return size
  }

  public override var alpha: CGFloat {
    didSet {
      for view in subviews {
        if view is CustomTabBarItemView {
          view.alpha = alpha
        } else {
          view.alpha = 0.0
        }
      }
    }
  }

  public override func addSubview(_ view: UIView) {
    if view is CustomTabBarItemView {
      super.addSubview(view)
    } else {
      super.insertSubview(view, at: 0)
    }
  }
}

extension UIViewController {
  @objc open func customTabBarItemContentView() -> CustomTabBarItemView {
    fatalError("Must be implemented in subclass")
  }

  public var customTabBarController: CustomTabBarController? {
    return self.tabBarController as? CustomTabBarController
  }
}

public class CustomTabBarController: UITabBarController {

  @IBInspectable public var preferedHeight: CGFloat = defaultHeight {
    didSet {
      customTabBar.preferedHeight = preferedHeight
      view.setNeedsLayout()
      selectedViewController?.view.setNeedsLayout()
    }
  }

  public var customTabBar: CustomTabBar {
    return self.tabBar as! CustomTabBar // swiftlint:disable:this force_cast
  }

  public var customItems: [CustomTabBarItem] {
    let items = tabBar.items as? [CustomTabBarItem]
    assert(items != nil, "All tab bar items must be `AZTabBarItem` class")
    return items ?? []
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    assert(tabBar is CustomTabBar, "tabBar class must be `AZTabBar` class")
    customTabBar.customTabBarController = self
    customCreateViewContainers()
  }

  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()

    for item in customItems {
      item.containerView._preferedHeight = preferedHeight
      item.containerView.heightConstraint.constant = item.containerView.preferedHeight
    }
  }

  // MARK: - Setup

  private func customCreateViewContainers() {
    for (index, item) in customItems.enumerated() {
      let viewContainer = customSetupView(onItem: item, index: index)

      if index == 0 {
        item.setSelected(true, animated: false)
      } else {
        item.setSelected(false, animated: false)
      }

      tabBar.addSubview(viewContainer)
      tabBar.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor).isActive = true

      if index > 0 {
        customItems[index - 1].containerView.rightAnchor.constraint(equalTo: viewContainer.leftAnchor).isActive = true
        customItems[index - 1].containerView.widthAnchor.constraint(equalTo: viewContainer.widthAnchor).isActive = true
      }
    }

    if let firstItem = customItems.first, let lastItem = customItems.last {
      tabBar.leftAnchor.constraint(equalTo: firstItem.containerView.leftAnchor).isActive = true
      tabBar.rightAnchor.constraint(equalTo: lastItem.containerView.rightAnchor).isActive = true
    }

    tabBar.alpha = 1
    tabBar.shadowImage = UIImage()
    tabBar.backgroundImage = UIImage()
  }

  private func customSetupView(onItem item: CustomTabBarItem, index: Int) -> CustomTabBarItemView {
    let viewContainer = customTabBarItem(forViewController: viewControllers![index])
    viewContainer.index = index
    viewContainer._preferedHeight = preferedHeight

    let tapGesture = UILongPressGestureRecognizer(target: self,
                                                  action: #selector(CustomTabBarController.customTapHandler(_:)))
    tapGesture.minimumPressDuration = 0
    viewContainer.addGestureRecognizer(tapGesture)

    viewContainer.heightConstraint =
      viewContainer.heightAnchor.constraint(equalToConstant: viewContainer.preferedHeight)
    viewContainer.heightConstraint.isActive = true

    item.containerView = viewContainer
    return viewContainer
  }

  private func customTabBarItem(forViewController viewController: UIViewController) -> CustomTabBarItemView {
    if let navigationController = viewController as? UINavigationController {
      return navigationController.viewControllers.first?.customTabBarItemContentView()
        ?? viewController.customTabBarItemContentView()
    }
    return viewController.customTabBarItemContentView()
  }

  // MARK: - Actions

  @objc private func customTapHandler(_ gesture: UIGestureRecognizer) {
    let currentIndex = (gesture.view as! CustomTabBarItemView).index // swiftlint:disable:this force_cast
    customSetSelectedIndex(currentIndex)
  }

  public override var selectedIndex: Int {
    didSet {
      customSetSelectedIndex(selectedIndex, posible: oldValue)
    }
  }

  private func customSetSelectedIndex(_ currentIndex: Int, posible oldIndex: Int? = nil) {
    if oldIndex ?? selectedIndex != currentIndex {
      let selectedItem: CustomTabBarItem = customItems[currentIndex]
      selectedItem.setSelected(true, animated: true)

      let deselectedItem = customItems[oldIndex ?? selectedIndex]
      deselectedItem.setSelected(false, animated: true)
      selectedIndex = currentIndex
    }
  }
}
