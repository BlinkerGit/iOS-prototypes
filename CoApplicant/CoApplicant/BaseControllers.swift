//
//  Created by Ben Pilcher on 2/28/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit

// Base controller that provides hidden 'back' button and shake-to-restart
class PrototypeController: UIViewController {

  var imageIndex: Int = -1
  let hiddenBackButton = UIButton()
  var mailComposer: MFMailComposeViewController?

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
    navigationController?.popViewController(animated: true)
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
      self.navigationController?.popToRootViewController(animated: true)
    }
  }

  var currentHotspot: UIButton?
  var currentImageView: UIImageView? { didSet { checkForTimedImage() } }

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
    guard !imageViews.isEmpty else {
      return
    }

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

func delay(_ delay: Double, closure: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

import MessageUI

extension PrototypeController:  MFMailComposeViewControllerDelegate {

  func sendEmail() {
    guard  MFMailComposeViewController.canSendMail() else  { return }
    guard self.mailComposer == nil else { return }

    let mailComposer = MFMailComposeViewController()
    mailComposer.mailComposeDelegate = self

    mailComposer.setSubject("Prototype feedback")
    let screenNumber = self.navigationController?.viewControllers.index(of: self) ?? 0
    let storyboard = self.storyboard
    let storyboardName = storyboard?.value(forKey: "name") ?? "n/a"
    var message = ""
    message.append("\nVersion: \"\(storyboardName)\"")
    message.append("\nScreen number: \(screenNumber)")
    mailComposer.setMessageBody(message, isHTML: false)

    self.mailComposer = mailComposer
    show(mailComposer, sender: nil)
  }

  func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
    dismiss(animated: true, completion: {
      self.mailComposer = nil
    })
  }
}

