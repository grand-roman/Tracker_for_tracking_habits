import UIKit

final class StatisticsViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.text = NSLocalizedString("statistics.title", comment: "")
        label.textColor = .ypBlackAdaptive
        label.font = .systemFont(ofSize: 34, weight: .bold)

        return label
    }()

    private let completedStatistic: StatisticView = {
        let view = StatisticView()
        view.configure(caption: NSLocalizedString("completedStatistic.caption", comment: ""))
        return view
    }()

    private let placeholderView: PlaceholderView = {
        let view = PlaceholderView()

        view.configure(
            image: UIImage(named: "StatisticsPlaceholder"),
            caption: NSLocalizedString("statisticsPlaceholder.caption", comment: "")
        )
        return view
    }()

    private let recordStore = RecordStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        recordStore.delegate = self

        makeViewLayout()
        storeDidChangeRecords()
    }

    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteAdaptive

        view.addSubview(titleLabel)
        view.addSubview(completedStatistic)
        view.addSubview(placeholderView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        completedStatistic.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            completedStatistic.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 80),
            completedStatistic.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedStatistic.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            placeholderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        view.layoutIfNeeded()
        drawBorderAroundCompletedStatistic()
    }

    private func drawBorderAroundCompletedStatistic() {
        let shape = CAShapeLayer()
        let gradient = CAGradientLayer()

        shape.lineWidth = 2
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        shape.path = UIBezierPath(
            roundedRect: completedStatistic.bounds,
            cornerRadius: completedStatistic.layer.cornerRadius
        ).cgPath

        gradient.mask = shape
        gradient.frame = CGRect(origin: .zero, size: completedStatistic.frame.size)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [
            UIColor.ypRedGradient.cgColor,
            UIColor.ypGreenGradient.cgColor,
            UIColor.ypBlueGradient.cgColor
        ]
        completedStatistic.layer.addSublayer(gradient)
    }
}

extension StatisticsViewController: RecordStoreDelegate {

    func storeDidChangeRecords() {
        let recordsCount = recordStore.fetchedRecords.count

        if recordsCount == 0 {
            placeholderView.isHidden = false
            completedStatistic.isHidden = true
        } else {
            placeholderView.isHidden = true
            completedStatistic.isHidden = false
            completedStatistic.set(value: recordsCount)
        }
    }
}
