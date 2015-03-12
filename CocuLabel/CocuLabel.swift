import UIKit

class CocuLabel: UILabel {

    //priority color
    private var firstColor :UIColor?
    private var secondColor :UIColor?
    private var thirdColor :UIColor?
    
    //resolution when analyze color
    private let resolution :CGFloat = 0.1
    
    //
    private var saturationCoefficient :CGFloat = 0.75
    
    //
    var colorThreshold :CGFloat = 0.55
    
    
    // MARK: - public
    
    /**
        update color
    */
    func updateColor() {
        
        var originalHidden = self.hidden
        
        self.hidden = true
        
        self.dispatch_async_global {
        
            var image = self.captureBackImage()
            
            var colorList = self.getColorListFromImage(image)
            
            var sumColor = self.getSumColor(colorList)
            
            self.dispatch_async_main {
            
                if self.firstColor == nil ||
                    self.secondColor == nil ||
                    self.thirdColor == nil {
                    self.textColor = self.getInvertedColor(sumColor)
                } else {
                    self.textColor = self.getSatisfiedPriorityColor(sumColor)
                }
            
                self.hidden = false
                
                if originalHidden == true {
                    self.hidden = true
                }
            }
        }
    }
    
    /**
        set priority colors
    */
    func setPriorityColor(first :UIColor, second :UIColor, third :UIColor) {
        self.firstColor = first
        self.secondColor = second
        self.thirdColor = third
    }
    
    
    // MARK: - private
    
    /**
        increase saturation
    */
    private func increaseSaturation(color :UIColor) -> UIColor {
        var r :CGFloat = self.getRGBFromUIColor(color).r
        var g :CGFloat = self.getRGBFromUIColor(color).g
        var b :CGFloat = self.getRGBFromUIColor(color).b
        
        r = self.getSaturation(r)
        g = self.getSaturation(g)
        b = self.getSaturation(b)
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /**
        get color for increasing saturation.
        it's my original, and temporary
    */
    private func getSaturation(a :CGFloat) -> CGFloat {
        if a > 0.5 {
            return min(((a - 0.5) * (a - 0.5) * saturationCoefficient + a), 1.0)
        } else {
            return max(((a - 0.5) * (a - 0.5) * saturationCoefficient * (-1) + a), 0.0)
        }
    }
    
    /**
        capture image of label back
    */
    private func captureBackImage() -> UIImage {
        
        var frame = self.frame
        
        var top = UIApplication.sharedApplication().keyWindow?.rootViewController
        while((top?.presentedViewController) != nil) {
            top = top?.presentedViewController
        }
        
        //add margin for getting more optimized color
        frame = self.addMargin(frame, parentFrame: top!.view.frame)
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, resolution)
        var context = UIGraphicsGetCurrentContext()
        CGContextTranslateCTM(context, -frame.origin.x, -frame.origin.y)
        var layer = top?.view.layer
        layer?.renderInContext(context)
        var capture = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return capture
    }
    
    //test
    private func addMargin(targetFrame :CGRect, parentFrame :CGRect) -> CGRect {
        let margin :CGFloat = 40
        
        //TODO
        
        return CGRectMake(targetFrame.origin.x - margin, targetFrame.origin.y - margin,
                            targetFrame.width + margin * 2, targetFrame.height + margin * 2)
    }
    
    /**
        get color list from image
    */
    private func getColorListFromImage(image :UIImage) -> Array<UIColor> {
        
        var colorList = Array<UIColor>()

        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var w = CGImageGetWidth(image.CGImage)
        var h = CGImageGetHeight(image.CGImage)
        
        for var x :UInt = 0; x < w; x++ {
            for var y :UInt = 0; y < h; y++ {
                var pixelInfo: Int = Int(w * y + x) * 4
                var b = CGFloat(data[pixelInfo])
                var g = CGFloat(data[pixelInfo+1])
                var r = CGFloat(data[pixelInfo+2])
                colorList.append(UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: 1.0))
            }
        }

        return colorList
    }
    
    /**
        get inverted color
        (complementary color is better?? but complementary color of white is...white??)
    */
    private func getInvertedColor(color :UIColor) -> UIColor {
        
        var r :CGFloat = self.getRGBFromUIColor(color).r
        var g :CGFloat = self.getRGBFromUIColor(color).g
        var b :CGFloat = self.getRGBFromUIColor(color).b
        
        //rgbともに0.5から±0.15におさまるときは
        //反転してもあまり違いがでないので白か黒に寄せる
        if abs(r - 0.5) < 0.15 &&
            abs(g - 0.5) < 0.15 &&
            abs(b - 0.5) < 0.15 {
                
                var average = (r + g + b) / 3
                return average > 0.5 ? UIColor.blackColor() : UIColor.whiteColor()
        }
        
        return self.increaseSaturation(UIColor(red: 1 - r, green: 1 - g, blue: 1 - b, alpha: 1.0))
    }
    
    /**
        get sum color from color list 
        WIP!!!!
    */
    private func getSumColor(colorList :Array<UIColor>) -> UIColor {
        
        //TODO: what is better Alogolitm!!??
        
        var count = colorList.count
        var sumR :CGFloat = 0
        var sumG :CGFloat = 0
        var sumB :CGFloat = 0
        
        for color in colorList {
            sumR += self.getRGBFromUIColor(color).r
            sumG += self.getRGBFromUIColor(color).g
            sumB += self.getRGBFromUIColor(color).b
        }
        
        return UIColor(red: sumR / CGFloat(count), green: sumG / CGFloat(count), blue: sumB / CGFloat(count), alpha: 1.0)
    }
    
    /**
        get priority color which statisfied
    */
    private func getSatisfiedPriorityColor(targetColor :UIColor) -> UIColor {
        if self.isThresholdOver(targetColor, targetColor: self.firstColor!, threshold: self.colorThreshold) {
            return self.firstColor!
        } else if self.isThresholdOver(targetColor, targetColor: self.secondColor!, threshold: self.colorThreshold) {
            return self.secondColor!
        } else if self.isThresholdOver(targetColor, targetColor: self.thirdColor!, threshold: self.colorThreshold) {
            return self.thirdColor!
        } else {
            //if all priority colors don't satisfy, get inverted color
            return self.getInvertedColor(targetColor)
        }
    }
    
    /**
        check the color is threshold over
    */
    private func isThresholdOver(baseColor :UIColor, targetColor :UIColor, threshold :CGFloat) -> Bool {
        
        if abs(self.getRGBFromUIColor(targetColor).r - self.getRGBFromUIColor(baseColor).r) < threshold &&
            abs(self.getRGBFromUIColor(targetColor).g - self.getRGBFromUIColor(baseColor).g) < threshold &&
            abs(self.getRGBFromUIColor(targetColor).b - self.getRGBFromUIColor(baseColor).b) < threshold {
                return false
        }
        
        return true
    }
    
    // MARK: - helper method

    private func getRGBFromUIColor(color :UIColor) -> (r :CGFloat, g :CGFloat, b :CGFloat) {
        
        var r :CGFloat = 0
        var g :CGFloat = 0
        var b :CGFloat = 0
        var a :CGFloat = 1.0
        
        color.getRed(&r,
            green: &g,
            blue: &b,
            alpha: &a)
        
        return (r :r, g :g, b :b)
    }
    
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
    
    func dispatch_async_global(block: () -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
    }

}
