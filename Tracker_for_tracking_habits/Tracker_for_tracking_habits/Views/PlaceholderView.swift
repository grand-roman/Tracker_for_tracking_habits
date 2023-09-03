import UIKit

final class PlaceholderView: UIView {

    private let imageView: UIImageView = {
        let image = UIImageView()

        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true

        return image
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypBlackAdaptive
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .medium)
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

    func configure(image: UIImage?, caption: String) {
        imageView.image = image
        captionLabel.text = caption
    }

    private func makeViewLayout() {
        self.addSubview(imageView)
        self.addSubview(captionLabel)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            captionLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            captionLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8)
        ])
    }
}
