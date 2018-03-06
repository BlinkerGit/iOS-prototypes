//
//  Created by Ben Pilcher on 2/28/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit
import Fingertips

func delay(_ delay: Double, closure: @escaping () -> Void) {
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    let window = MBFingerTipWindow(frame: UIScreen.main.bounds)
    window.strokeColor = Color.blinkerBlue
    window.alwaysShowTouches = true
    window.fillColor = Color.blinkerBlue.withAlphaComponent(0.4)

    let initialController = UIStoryboard(name: "TableOfContents", bundle: nil).instantiateInitialViewController()

    window.rootViewController = initialController
    window.makeKeyAndVisible()
    self.window = window

    UIApplication.shared.isStatusBarHidden = true
    return true
  }
}

