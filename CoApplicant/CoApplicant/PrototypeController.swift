//
//  PrototypeController.swift
//  CoApplicant
//
//  Created by Ben Pilcher on 2/28/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit

class PrototypeController: UIViewController {

  override func becomeFirstResponder() -> Bool {
    return true
  }

  override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if motion == .motionShake {
      self.navigationController?.popToRootViewController(animated: true)
    }
  }

}
