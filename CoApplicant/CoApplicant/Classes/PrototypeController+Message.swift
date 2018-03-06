//
//  Created by Ben Pilcher on 3/5/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import Foundation
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
