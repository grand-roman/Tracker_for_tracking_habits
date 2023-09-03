import UIKit

extension UIColor {
    static let ypBackgroundAdaptive = UIColor(named: "YPBackgroundAdaptive")!
    static let ypBlackAdaptive = UIColor(named: "YPBlackAdaptive")!
    static let ypWhiteAdaptive = UIColor(named: "YPWhiteAdaptive")!
    
    static let ypBackground = UIColor(named: "YPBackground")!
    static let ypBlack = UIColor(named: "YPBlack")!
    static let ypWhite = UIColor(named: "YPWhite")!
    static let ypGray = UIColor(named: "YPGray")!
    static let ypLightGray = UIColor(named: "YPLightGray")!
    static let ypRed = UIColor(named: "YPRed")!
    static let ypBlue = UIColor(named: "YPBlue")!
    
    static let ypRedGradient = UIColor(named: "YPRedGradient")!
    static let ypGreenGradient = UIColor(named: "YPGreenGradient")!
    static let ypBlueGradient = UIColor(named: "YPBlueGradient")!
    
    static let ypSelection1 = UIColor(named: "YPSelection1")!
    static let ypSelection2 = UIColor(named: "YPSelection2")!
    static let ypSelection3 = UIColor(named: "YPSelection3")!
    static let ypSelection4 = UIColor(named: "YPSelection4")!
    static let ypSelection5 = UIColor(named: "YPSelection5")!
    static let ypSelection6 = UIColor(named: "YPSelection6")!
    static let ypSelection7 = UIColor(named: "YPSelection7")!
    static let ypSelection8 = UIColor(named: "YPSelection8")!
    static let ypSelection9 = UIColor(named: "YPSelection9")!
    static let ypSelection10 = UIColor(named: "YPSelection10")!
    static let ypSelection11 = UIColor(named: "YPSelection11")!
    static let ypSelection12 = UIColor(named: "YPSelection12")!
    static let ypSelection13 = UIColor(named: "YPSelection13")!
    static let ypSelection14 = UIColor(named: "YPSelection14")!
    static let ypSelection15 = UIColor(named: "YPSelection15")!
    static let ypSelection16 = UIColor(named: "YPSelection16")!
    static let ypSelection17 = UIColor(named: "YPSelection17")!
    static let ypSelection18 = UIColor(named: "YPSelection18")!
    
    static var tabBarBorderColor: UIColor = UIColor { trait in
        return trait.userInterfaceStyle == .light ? .ypGray : .ypBlack
    }
}
