import UIKit

final class OnboardingPageView: UIView {

    private let backgroundView = UIImageView()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypBlackDay
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.numberOfLines = 2

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        makeViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(background image: UIImage?, title: String) {
        backgroundView.image = image
        titleLabel.text = title
    }

    private func makeViewLayout() {
        self.addSubview(backgroundView)
        self.addSubview(titleLabel)

        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),

            titleLabel.topAnchor.constraint(equalTo: backgroundView.centerYAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16)
            ])
    }
}
