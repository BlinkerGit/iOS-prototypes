//
//  UIColor+Utils.swift
//  CoApplicant
//
//  Created by Ben Pilcher on 3/5/18.
//  Copyright © 2018 Ben Pilcher. All rights reserved.
//

import UIKit

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
