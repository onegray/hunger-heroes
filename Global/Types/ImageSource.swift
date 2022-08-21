//
//  ImageSource.swift
//  HungerHeroes
//
//  Created by onegray on 21.08.22.
//

import Foundation
import CoreGraphics

protocol ImageSource: AnyObject {
    func getImage(_ handler: (CGImage)->(Void))
}
