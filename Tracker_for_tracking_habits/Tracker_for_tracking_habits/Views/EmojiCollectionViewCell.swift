import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {

    static let identifier = "EmojiCollectionViewCell"

    private let canvasView: UIView = {
        let view = UIView()

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.widthAnchor.constraint(equalToConstant: 52).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32, weight: .bold)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        makeViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(emoji: String) {
        emojiLabel.text = emoji
    }

    func selectEmoji() {
        canvasView.backgroundColor = .ypLightGray
    }

    func deselectEmoji() {
        canvasView.backgroundColor = .ypWhiteAdaptive
    }

    private func makeViewLayout() {
        contentView.addSubview(canvasView)
        contentView.addSubview(emojiLabel)

        canvasView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            canvasView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            canvasView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            emojiLabel.centerXAnchor.constraint(equalTo: canvasView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: canvasView.centerYAnchor)
        ])
    }
}
