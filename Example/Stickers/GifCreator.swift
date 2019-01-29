//
//  gifCreator.swift
//  Stickers_Example
//
//  Created by Alexis Suard on 25/01/2019.
//  Copyright © 2019 Louis Vuitton. All rights reserved.
//
import Foundation
import UIKit
import Stickers
import ImageIO
import MobileCoreServices

class GifCreator: UIViewController {
    
    let gifimageView = GIFImageView(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
    let gifimageView2 = GIFImageView(frame: CGRect(x: 200, y: 600, width: 100, height: 100))
    let gifimageView3 = GIFImageView(frame: CGRect(x: 300, y: 300, width: 100, height: 100))
    let gifimageView4 = GIFImageView(frame: CGRect(x: 300, y: 600, width: 100, height: 100))
    let gifimageView5 = GIFImageView(frame: CGRect(x: 100, y: 150, width: 100, height: 100))
    let gifimageView6 = GIFImageView(frame: CGRect(x: 200, y: 250, width: 100, height: 100))
    
    var timer = Timer()
    var images = [UIImage]()
    
    var gifImages = [GIFImageView]()
    var timeInterval: Double = 0.0
    var numberOfFrames = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(gifimageView)
        self.view.addSubview(gifimageView2)
        self.view.addSubview(gifimageView3)
        self.view.addSubview(gifimageView4)
        self.view.addSubview(gifimageView5)
        self.view.addSubview(gifimageView6)
        
        gifimageView.animate(withGIFNamed: "LV_Lantern_320x320.gif") {
            print(self.gifimageView.frameCount)
        }
        gifimageView2.animate(withGIFNamed: "LV_Kumquat_320x320.gif") {
            print(self.gifimageView2.frameCount)
        }
        gifimageView3.animate(withGIFNamed: "LV_Flower_320x320.gif") {
            print(self.gifimageView3.frameCount)
        }
        gifimageView4.animate(withGIFNamed: "LV_Firework_320x320.gif") {
            
        }
        gifimageView5.animate(withGIFNamed: "LV_Candy_320x320.gif") {
            print(self.gifimageView5.frameCount)
        }
        gifimageView6.animate(withGIFNamed: "LV_Charm_320x320.gif") {
            print(self.gifimageView3.frameCount)
        }
        gifImages = [gifimageView, gifimageView2, gifimageView3, gifimageView4, gifimageView5, gifimageView6]
    }
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: self.timeInterval, target: self, selector: #selector(self.takeScreenshot), userInfo: nil, repeats: true)
    }
    
    
    
    @IBAction func takeScreen(_ sender: Any) {
        if let double = calculateMinimumLoopDuration() {
            self.timeInterval = double.time
            self.numberOfFrames = double.frame
            print(double)
            scheduledTimerWithTimeInterval()
            DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + Double(numberOfFrames) * timeInterval, execute: {
                UIImage.animatedGif(from: self.images)
                self.timer.invalidate()
                
            })

        }
    }
    
    @objc public func takeScreenshot() {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
        self.view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.images.append(image!)
    }

    
    public func calculateMinimumLoopDuration() -> (frame: Int, time: Double)? {
        if !self.gifImages.isEmpty {
            var durationArray = [Double]()
            var frameToFind = 0
            var frameArray = [Int]()
            var timeInterVal = 0.0
            gifImages.forEach { (image) in
                if image.gifLoopDuration != 0.0 {
                    let duration = Double(round(10*image.gifLoopDuration)/10)
                    if image.frameCount > frameToFind {
                        frameToFind = image.frameCount
                    }
                    durationArray.append( duration) // 2 digits precision for video length
                    timeInterVal += (duration / Double(image.frameCount))
                    frameArray.append(image.frameCount)
                }
            }
            if !frameArray.isEmpty {
                timeInterVal = timeInterVal / Double(frameArray.count)
                var minFrame = 0
                let maxDuration = frameToFind
                while minFrame == 0 {
                    var isFound = true
                    for frame in frameArray {
                        if frameToFind % frame != 0  {
                            isFound = false
                            frameToFind += maxDuration
                            break
                        }
                    }
                    if isFound {
                        minFrame = frameToFind
                    }
                }
                return (minFrame, timeInterVal)
            }
            return nil
        }
        return nil
    }
}



extension UIImage {
    
    
    
    static func animatedGif(from images: [UIImage]) {
        let fileProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]  as CFDictionary
        let frameProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [(kCGImagePropertyGIFDelayTime as String): 0.08]] as CFDictionary
        
        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL: URL? = documentsDirectoryURL?.appendingPathComponent("animated.gif")
        
        if let url = fileURL as CFURL? {
            if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) {
                CGImageDestinationSetProperties(destination, fileProperties)
                for image in images {
                    if let cgImage = image.cgImage {
                        CGImageDestinationAddImage(destination, cgImage, frameProperties)
                    }
                }
                if !CGImageDestinationFinalize(destination) {
                    print("Failed to finalize the image destination")
                }
                print("Url = \(fileURL)")
            }
        }
    }
}
