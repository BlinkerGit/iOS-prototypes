//
//  Created by Ben Pilcher on 3/4/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit
import AudioToolbox

class CameraSnapButton: UIButton {

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)

    if #available(iOS 9.0, *) {
      AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
    } else {
      AudioServicesPlaySystemSound(1108)
    }
  }
}
