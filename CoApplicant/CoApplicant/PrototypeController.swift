//
//  PrototypeController.swift
//  CoApplicant
//
//  Created by Ben Pilcher on 2/28/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit

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
