import UIKit

final class StatisticView: UIView {

    private let valueLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypBlackAdaptive
        label.font = .systemFont(ofSize: 34, weight: .bold)

        return label
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypBlackAdaptive
        label.font = .systemFont(ofSize: 12, weight: .medium)

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        makeViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(caption: String) {
        valueLabel.text = "0"
        captionLabel.text = caption
    }

    func set(value: Int) {
        valueLabel.text = String(value)
    }

    private func makeViewLayout() {
        self.heightAnchor.constraint(equalToConstant: 90).isActive = true

        self.layer.masksToBounds = true
        self.layer.cornerRadius = 16

        self.addSubview(valueLabel)
        self.addSubview(captionLabel)

        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            valueLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12),
            valueLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),

            captionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            captionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12)
        ])
    }
}
