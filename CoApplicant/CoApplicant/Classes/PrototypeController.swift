//
//  Created by Ben Pilcher on 2/28/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit
import MessageUI

// Base controller that provides hidden 'back' button and shake-to-restart
class PrototypeController: UIViewController {

  var imageIndex: Int = -1
  let hiddenBackButton = UIButton()
  var mailComposer: MFMailComposeViewController?
  var currentHotspot: UIButton?
  var currentImageView: UIImageView? { didSet { checkForTimedImage() } }

  override func viewDidLoad() {
    super.viewDidLoad()

    let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.didLongPress))
    longPress.minimumPressDuration = 1.5
    view.addGestureRecognizer(longPress)

    hiddenBackButton.frame = CGRect(x: 0.0, y: 0.0, width: 100.0, height: 60.0)
    view.addSubview(hiddenBackButton)
    hiddenBackButton.addTarget(self, action: #selector(self.goBack), for: .touchUpInside)
    goToNext()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    view.addSubview(hiddenBackButton)
  }

  @objc
  func goBack() {
    if self.presentingViewController != nil {
      self.presentingViewController?.dismiss(animated: true, completion: nil)
    } else {
      navigationController?.popViewController(animated: true)
    }
  }
  
  @objc
  func didLongPress() {
    sendEmail()
  }

  // MARK - Shake to pop to root
  override func becomeFirstResponder() -> Bool {
    return true
  }

  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      if presentingViewController != nil {
        let parent = self.presentingViewController as! UINavigationController
        parent.dismiss(animated: true, completion: {
          parent.popToRootViewController(animated: true)
        })
      } else {
        navigationController?.popToRootViewController(animated: true)
      }
    }
  }

  func checkForTimedImage() {
    guard let current = currentImageView else { return }

    if current is TimedImageView {
      self.view.isUserInteractionEnabled = false
      delay(0.8, closure: {
        self.currentHotspot?.sendActions(for: .touchUpInside)
        self.view.isUserInteractionEnabled = false
      })
    }
  }

  func goToNext() {
    guard !imageViews.isEmpty else { return }

    imageIndex = imageIndex + 1
    if imageIndex == imageViews.count {
      imageIndex = 0
    }
    let current = imageViews[imageIndex]
    current.isHidden = false
    view.addSubview(current)

    currentImageView = current

    for button in hotspots {
      button?.isEnabled = false
    }

    if let hotspot = hotspots[safe: imageIndex], let button = hotspot {
      button.isEnabled = true
      view.addSubview(button)
      currentHotspot = hotspot
    }

    view.addSubview(hiddenBackButton)
    hiddenBackButton.isEnabled = true
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
