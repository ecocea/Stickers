//
//  DraggableImageView.swift
//  Stickers
//
//  Created by Alexis Suard on 12/03/2018.
//

import Foundation
import UIKit
import AVFoundation


public protocol DraggableItemDelegate {
    func isMoving() -> Void
    func isStopping() -> Void
}

class DraggableImageView: GIFImageView {
    
    var delegate: DraggableItemDelegate?
    var binZone: CGRect?
    var rotated: CGFloat = 0
    let impact = UIImpactFeedbackGenerator()
    var binCenter: CGPoint? {
        if let binZone = binZone {
            return CGPoint(x: binZone.origin.x + binZone.width/2, y: binZone.origin.y + binZone.height/2)
        }
        return nil
    }
    
    var currentSize: CGSize?
    var distanceFromTouch: CGSize?
    
    func setup(with superView: UIView) {
        superView.addSubview(self)
        self.isUserInteractionEnabled = true
        
        let rectRationed = AVMakeRect(aspectRatio: self.frame.size, insideRect: CGRect(origin: self.frame.origin, size: CGSize(width: 200, height: 200)))
        self.frame.size = rectRationed.size
        if let superView = self.superview {
            self.frame.origin.x = superView.frame.width/2 - self.frame.width/2
            self.frame.origin.y = superView.frame.height/2 - self.frame.height/2
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(recognizer:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc func handlePan(recognizer: UIPanGestureRecognizer) {
        guard let superView = self.superview else { return }
        
        let translation = recognizer.translation(in: superView)
        if let view = recognizer.view {
            superView.bringSubview(toFront: view)
            view.center = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
            
            switch recognizer.state {
            case .changed, .began:
                delegate?.isMoving()
                
                let touch = recognizer.location(ofTouch: 0, in: superView)
                
                if let binZone = binZone, isInBinZone(touch) {
                    animateInBin(binZone: binZone, touch: touch)
                } else {
                    animateOutBinFrom(touch: touch)
                }
            case .ended:
                if isInBinZone(self.center) {
                    self.removeFromSuperview()
                }
                delegate?.isStopping()
            default:
                delegate?.isStopping()
            }
        }
        recognizer.setTranslation(CGPoint.zero, in: superView)
    }
    
    func animateInBin(binZone: CGRect, touch: CGPoint) {
        if currentSize == nil {
            //Rotate first
            let zKeyPath = "layer.presentationLayer.transform.rotation.z"
            let imageRotation = (self.value(forKeyPath: zKeyPath) as? NSNumber)?.floatValue ?? 0.0
            self.rotated = CGFloat(imageRotation)
            self.transform = self.transform.rotated(by: -self.rotated)
            currentSize = self.frame.size
            distanceFromTouch = CGSize(width: touch.x-self.frame.origin.x, height: touch.y-self.frame.origin.y)
            impact.impactOccurred()
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.size.width = 30
            self.frame.size.height = 30
            self.center = self.binCenter!
        })
    }
    
    func animateOutBinFrom(touch: CGPoint) {
        if let currentSize = self.currentSize, let distanceFromTouch = self.distanceFromTouch {
            UIView.animate(withDuration: 0.2, animations: {
                self.frame.origin = CGPoint(x: touch.x-distanceFromTouch.width, y: touch.y-distanceFromTouch.height)
                self.frame.size.width = currentSize.width
                self.frame.size.height = currentSize.height
                self.transform = self.transform.rotated(by: self.rotated)
                
            })
            self.currentSize = nil
            self.distanceFromTouch = nil
            self.rotated = 0
        }
    }
    
    func isInBinZone(_ touch: CGPoint) -> Bool {
        guard let binCenter = binCenter else { return false }
        if touch.x > binCenter.x - 40 && touch.x < binCenter.x + 40 && touch.y > binCenter.y - 40 && touch.y < binCenter.y + 40 {
            return true
        }
        return false
    }
}
