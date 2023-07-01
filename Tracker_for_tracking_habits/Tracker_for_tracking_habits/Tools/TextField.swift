import UIKit

final class TextField: UISearchTextField {
    
    func setUpTextFieldOnTrackerView() {
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.YPBackground.cgColor
        textColor = .YPBlack
        clearButtonMode = .whileEditing
        placeholder = "Поиск"
        font = UIFont.systemFont(ofSize: 17)
    }
    
    func setUpTextFieldOnCreateTracker() {
        layer.cornerRadius = 10
        leftView = nil
        layer.backgroundColor = UIColor.YPBackground.cgColor
        textColor = .YPBlack
        clearButtonMode = .whileEditing
        placeholder = "Введите название трекера"
        font = UIFont.systemFont(ofSize: 17)
    }
}
