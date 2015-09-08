import UIKit

extension UIColor {
    class func rgb(#r: Int, g: Int, b: Int, alpha: CGFloat) -> UIColor{
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha)
    }
    class func DefaultColor() -> UIColor {
        return UIColor.rgb(r: 19, g: 121, b: 255, alpha: 1.0)
    }
}