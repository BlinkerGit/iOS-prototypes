//
//  Created by Ben Pilcher on 2/28/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit

// Base controller that provides hidden 'back' button and shake-to-restart
class PrototypeController: UIViewController {

  var imageIndex: Int = -1
  let hiddenBackButton = UIButton()

  override func viewDidLoad() {
    super.viewDidLoad()

    hiddenBackButton.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 60.0)
    view.addSubview(hiddenBackButton)
    hiddenBackButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    view.addSubview(hiddenBackButton)
  }

  @objc
  func goBack() {
    navigationController?.popViewController(animated: true)
  }

  override func becomeFirstResponder() -> Bool {
    return true
  }

  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      self.navigationController?.popToRootViewController(animated: true)
    }
  }

  func goToNext() {
    guard !imageViews.isEmpty else {
      return
    }

    imageIndex = imageIndex + 1
    if imageIndex == imageViews.count {
      imageIndex = 0
    }
    let currentImageViews = imageViews[imageIndex]
    currentImageViews.isHidden = false
    view.addSubview(currentImageViews)

    for button in hotspots {
      button?.isEnabled = false
    }

    if let hotspot = hotspots[safe: imageIndex], let button = hotspot {
      button.isEnabled = true
      view.addSubview(button)
    }

    view.addSubview(hiddenBackButton)
  }

  var hotspots: [UIButton?] {
    var hotspotButtons: [UIButton] = []
    for button in (view.subviews.filter { $0 is UIButton && $0 != hiddenBackButton }) {
      hotspotButtons.append(button as! UIButton)
    }

    var values: [UIButton?] = []
    for (i, _) in imageViews.enumerated() {
      if let hotspot = (hotspotButtons.filter {$0.tag == i }.first) {
        values.append(hotspot)
      } else {
        values.append(nil)
      }
    }

    return values
  }

  var imageViews: [UIImageView] {
    var views: [UIImageView] = []
    for child in (view.subviews.filter { $0 is UIImageView }) {
      views.append(child as! UIImageView)
      child.isUserInteractionEnabled = true
      child.alpha = 1
    }
    return views.sorted { $0.tag < $1.tag }
  }
}

// Simulate filling in a form (or cause a state change) by tapping
class TapController: PrototypeController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
    view.addGestureRecognizer(tapGesture)

    goToNext()
  }

  @IBAction func didTap() {
    goToNext()
  }
}

// Add as many image views as you want, assign tags in order of presention, and then swipe down
// to cycle through and show variants. To
class SwipeController: PrototypeController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let verticalSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe))
    verticalSwipeGesture.direction = .down
    view.addGestureRecognizer(verticalSwipeGesture)

    for button in hotspots {
      button?.isEnabled = false
    }

    goToNext()
  }

  @objc func didSwipe() {
    goToNext()
  }
}

extension Array {
  subscript(safe index: Int) -> Element? {
    return Int(index) < count ? self[Int(index)] : nil
  }
}
