import UIKit

final class CheckTableViewCell: UITableViewCell {

    static let identifier = "CheckTableViewCell"

    var viewModel: CategoryViewModel! {
        didSet {
            nameLabel.text = viewModel.title
            checkImage.image = viewModel.isChecked ? UIImage(systemName: "checkmark") : UIImage()
        }
    }

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypBlackDay
        label.font = .systemFont(ofSize: 17, weight: .regular)

        return label
    }()

    private let checkImage = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        makeViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func makeViewLayout() {
        contentView.backgroundColor = .ypBackgroundDay
        contentView.heightAnchor.constraint(equalToConstant: 75).isActive = true

        contentView.addSubview(nameLabel)
        contentView.addSubview(checkImage)

        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        checkImage.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            checkImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            checkImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
    }
}
