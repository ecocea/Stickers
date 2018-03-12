//
//  UIView+Utilities.swift
//  Stickers
//
//  Created by Alexis Suard on 12/03/2018.
//

import Foundation
extension UIView {
    func isIn(_ view: UIView? ) -> Bool {
        var superView = self.superview
        while superView != nil {
            if superView == view {
                return true
            }
            superView = superView?.superview
        }
        return false
    }
}
