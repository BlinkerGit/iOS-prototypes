//
//  AppDelegate.swift
//  CoApplicant
//
//  Created by Ben Pilcher on 2/28/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit
import Fingertips

extension UIColor {
  public convenience init(hex: Int) {
    let components = (
      R: CGFloat((hex >> 16) & 0xff) / 255,
      G: CGFloat((hex >> 08) & 0xff) / 255,
      B: CGFloat((hex >> 00) & 0xff) / 255
    )
    self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
  }
}

public enum Color {
  public static let dark = UIColor(hex: 0x2B3642)
  public static let slateGrey = UIColor(hex: 0x586374)
  public static let blinkerBlue = UIColor(hex: 0x00E6FF)
  public static let coolGrey = UIColor(hex: 0x92A0AB)
  public static let popBlue = UIColor(hex: 0x007AFF)
  public static let paleGrey = UIColor(hex: 0xE5E8EB)
  public static let errorPink = UIColor(hex: 0xFF3366)
  public static let organicBlue = UIColor(hex: 0x81F7F7)

  // UIColor defaults
  public static let white = UIColor.white
  public static let black = UIColor.black
  public static let clear = UIColor.clear

  public static let yellow = UIColor(hex: 0xFFC857)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    window = MBFingerTipWindow(frame: UIScreen.main.bounds)
    (window as! MBFingerTipWindow).strokeColor = Color.blinkerBlue

    let initialController = UIStoryboard(name: "TableOfContents", bundle: nil).instantiateInitialViewController()

    window!.rootViewController = initialController
    window!.makeKeyAndVisible()

    UIApplication.shared.isStatusBarHidden = true
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

