import UIKit

final class UIColorSerializer {

    func serialize(color: UIColor) -> String {
        let components = color.cgColor.components

        let red = components?[0] ?? 0
        let green = components?[1] ?? 0
        let blue = components?[2] ?? 0

        return String(
            format: "#%02X%02X%02X",
            Int(red * 255),
            Int(green * 255),
            Int(blue * 255)
        )
    }

    func deserialize(hex: String) -> UIColor {
        let value = hex.replacingOccurrences(of: "#", with: "")

        func component(start: Int, length: Int) -> String {
            let startIndex = value.index(value.startIndex, offsetBy: start)
            let endIndex = value.index(startIndex, offsetBy: length)
            return String(value[startIndex..<endIndex])
        }

        func hexToDec(component: String) -> CGFloat {
            return CGFloat(Int(component, radix: 16) ?? 0) / 255
        }

        let components = (
            component(start: 0, length: 2),
            component(start: 2, length: 2),
            component(start: 4, length: 2)
        )

        return UIColor(
            red: hexToDec(component: components.0),
            green: hexToDec(component: components.1),
            blue: hexToDec(component: components.2),
            alpha: 1
        )
    }
}
