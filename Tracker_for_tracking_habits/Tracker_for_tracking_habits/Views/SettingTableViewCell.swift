import UIKit

final class SettingTableViewCell: UITableViewCell {

    static let identifier = "SettingTableViewCell"

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypBlackAdaptive
        label.font = .systemFont(ofSize: 17, weight: .regular)

        return label
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypGray
        label.font = .systemFont(ofSize: 17, weight: .regular)

        return label
    }()

    private let accessoryImage: UIImageView = {
        return UIImageView(image: UIImage(named: "ChevronRightSymbol"))
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        makeViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(options: SettingOptions) {
        nameLabel.text = options.name
    }

    func configure(caption: String) {
        captionLabel.text = caption
    }

    private func makeViewLayout() {
        contentView.backgroundColor = .ypBackgroundAdaptive
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true

        let labelStack = makeLabelStack()

        contentView.addSubview(labelStack)
        contentView.addSubview(accessoryImage)

        labelStack.translatesAutoresizingMaskIntoConstraints = false
        accessoryImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            labelStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            accessoryImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            accessoryImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }

    private func makeLabelStack() -> UIStackView {
        let stack = UIStackView()

        stack.axis = .vertical

        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(captionLabel)

        return stack
    }
}
