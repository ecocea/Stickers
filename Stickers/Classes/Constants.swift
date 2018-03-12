//
//  Constants.swift
//  Kingfisher
//
//  Created by Alexis Suard on 12/03/2018.
//

import Foundation
import UIKit

struct Constants {
    
    enum Section: CGFloat {
        case low = 0
        case mid = 300
        case high = 600
        
        static func chooseSection(fromVelocity velocity: CGFloat, andHeight height: CGFloat) -> Section {
            if velocity < 0 { //Moving up
                if height <= UIScreen.main.bounds.height - Constants.Section.low.rawValue && height >= UIScreen.main.bounds.height - Constants.Section.mid.rawValue {
                    return .mid
                } else {
                    return .high
                }
            } else { //Moving dow
                if height <= UIScreen.main.bounds.height - Constants.Section.mid.rawValue && height >= UIScreen.main.bounds.height - Constants.Section.high.rawValue {
                    return .mid
                } else if height < UIScreen.main.bounds.height - Section.high.rawValue {
                    return .high
                } else {
                    return .low
                }
            }
        }
    }
    
    enum StickerSource {
        case image(UIImage)
        case url(URL)
    }
}
