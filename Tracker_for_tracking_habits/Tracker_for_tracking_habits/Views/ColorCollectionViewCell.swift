import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {

    static let identifier = "ColorCollectionViewCell"

    private let canvasView: UIView = {
        let view = UIView()

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.widthAnchor.constraint(equalToConstant: 52).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor.ypWhiteAdaptive.cgColor

        return view
    }()

    private let colorView: UIView = {
        let view = UIView()

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 8
        view.widthAnchor.constraint(equalToConstant: 40).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        makeViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(color: UIColor) {
        colorView.backgroundColor = color
    }

    func selectColor() {
        canvasView.layer.borderColor = colorView.backgroundColor?.withAlphaComponent(0.3).cgColor
    }

    func deselectColor() {
        canvasView.layer.borderColor = UIColor.ypWhiteAdaptive.cgColor
    }

    private func makeViewLayout() {
        contentView.addSubview(canvasView)
        contentView.addSubview(colorView)

        canvasView.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            canvasView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            canvasView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            colorView.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor)
        ])
    }
}
