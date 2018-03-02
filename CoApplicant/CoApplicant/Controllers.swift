//
//  Created by Ben Pilcher on 2/28/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit

// Base controller that provides hidden 'back' button and shake-to-restart
class PrototypeController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let hiddenBackButton = UIButton()
    hiddenBackButton.frame = CGRect.init(x: 0.0, y: 0.0, width: 100.0, height: 60.0)
    view.addSubview(hiddenBackButton)
    hiddenBackButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
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

}

// Use this for controllers that have a state change (ie driver's license capture -> image captured)
class CrossFadeController: PrototypeController {

  @IBOutlet weak var first: UIImageView!
  @IBOutlet weak var second: UIImageView!
  @IBOutlet weak var secondHotspot: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()

    secondHotspot.isEnabled = false
  }

  @IBAction func tappedHotspot(_ sender: Any) {
    view.addSubview(second)
    secondHotspot.isEnabled = true
    view.addSubview(secondHotspot)
  }
}

// Add as many image views as you want, assign tags in order of presention, and then swipe down
// to cycle through and show variants
class ABController: PrototypeController {

  override func viewDidLoad() {
    super.viewDidLoad()

    let verticalSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.didSwipe))
    verticalSwipeGesture.direction = .down
    view.addGestureRecognizer(verticalSwipeGesture)

    didSwipe()
  }

  var hotspots: [UIButton] {
    var views: [UIButton] = []
    for child in (view.subviews.filter { $0 is UIButton }) {
      views.append(child as! UIButton)
    }
    return views
  }

  var imageViews: [UIImageView] {
    var views: [UIImageView] = []
    for child in (view.subviews.filter { $0 is UIImageView }) {
      views.append(child as! UIImageView)
    }
    return views
  }

  var imageIndex: Int = -1

  @objc func didSwipe() {
    let variants = imageViews.sorted { $0.tag < $1.tag }
    guard !variants.isEmpty else {
      return
    }

    imageIndex = imageIndex + 1
    if imageIndex == variants.count {
      imageIndex = 0
    }
    view.addSubview(variants[imageIndex])
  }
}
