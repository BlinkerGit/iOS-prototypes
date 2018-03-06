//
//  Created by Ben Pilcher on 3/5/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit

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
