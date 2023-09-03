import UIKit

protocol TrackerCollectionViewCellDelegate: AnyObject {
    func completeTracker(with id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(with id: UUID, at indexPath: IndexPath)
}

final class TrackerCollectionViewCell: UICollectionViewCell {

    static let identifier = "TrackerCollectionViewCell"
    weak var delegate: TrackerCollectionViewCellDelegate?

    private let canvasView: UIView = {
        let view = UIView()

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.heightAnchor.constraint(equalToConstant: 90).isActive = true

        return view
    }()

    private let emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypBackground

        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        view.widthAnchor.constraint(equalToConstant: 24).isActive = true
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true

        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let pinImage: UIImageView = {
        let image = UIImageView()

        image.widthAnchor.constraint(equalToConstant: 24).isActive = true
        image.heightAnchor.constraint(equalTo: image.widthAnchor).isActive = true

        return image
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypWhite
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2

        return label
    }()

    private let counterLabel: UILabel = {
        let label = UILabel()

        label.textColor = .ypBlackAdaptive
        label.font = .systemFont(ofSize: 12, weight: .medium)

        return label
    }()

    private lazy var incrementButton: UIButton = {
        let button = UIButton(type: .custom)

        button.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 17
        button.widthAnchor.constraint(equalToConstant: 34).isActive = true
        button.heightAnchor.constraint(equalTo: button.widthAnchor).isActive = true

        button.addTarget(self, action: #selector(incrementDayCounter), for: .touchUpInside)
        return button
    }()

    private var trackerID: UUID?
    private var indexPath: IndexPath?
    private var isCompleted: Bool?
    private var isHabit: Bool?

    override init(frame: CGRect) {
        super.init(frame: frame)

        makeViewLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        counterLabel.text?.removeAll()
        incrementButton.setImage(UIImage(), for: .normal)
    }

    func configure(model: TrackerModel, at indexPath: IndexPath, isCompleted: Bool, completedDays: Int) {
        self.trackerID = model.id
        self.indexPath = indexPath
        self.isCompleted = isCompleted
        self.isHabit = !model.schedule.isEmpty

        canvasView.backgroundColor = model.color
        emojiLabel.text = model.emoji
        pinImage.image = model.isPinned ? UIImage(named: "PinSymbol") : UIImage()
        nameLabel.text = model.name

        if isHabit! {
            setCounter(days: completedDays)

            let image = isCompleted ? UIImage(named: "CheckMarkButton") : UIImage(named: "PlusButton")
            incrementButton.setImage(image?.withTintColor(.ypWhiteAdaptive), for: .normal)
            incrementButton.backgroundColor = isCompleted ? model.color.withAlphaComponent(0.3) : model.color
        } else {
            incrementButton.backgroundColor = model.color
        }
    }

    private func setCounter(days: Int) {
        counterLabel.text = String.localizedStringWithFormat(NSLocalizedString("completedDays", comment: ""), days)
    }

    @objc private func incrementDayCounter() {
        guard isHabit!,
            let isCompleted = isCompleted,
            let trackerID = trackerID,
            let indexPath = indexPath
            else {
            return
        }
        AnalyticService.shared.report(event: "click", with: ["screen": "Main", "item": "track"])

        if isCompleted {
            delegate?.uncompleteTracker(with: trackerID, at: indexPath)
        } else {
            delegate?.completeTracker(with: trackerID, at: indexPath)
        }
    }

    private func makeViewLayout() {
        contentView.addSubview(canvasView)
        contentView.addSubview(emojiView)
        contentView.addSubview(emojiLabel)
        contentView.addSubview(pinImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(counterLabel)
        contentView.addSubview(incrementButton)

        canvasView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        pinImage.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        incrementButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: contentView.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            emojiView.topAnchor.constraint(equalTo: canvasView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor, constant: 12),

            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor),

            pinImage.topAnchor.constraint(equalTo: canvasView.topAnchor, constant: 12),
            pinImage.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor, constant: -4),

            nameLabel.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor, constant: -12),
            nameLabel.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor, constant: -12),

            counterLabel.centerYAnchor.constraint(equalTo: incrementButton.centerYAnchor),
            counterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),

            incrementButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            incrementButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}
