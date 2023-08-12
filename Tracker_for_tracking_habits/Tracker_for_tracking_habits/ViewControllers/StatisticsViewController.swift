import UIKit

final class StatisticsViewController: UIViewController {

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.text = NSLocalizedString("statistics.title", comment: "")
        label.textColor = .ypBlackAdaptive
        label.font = .systemFont(ofSize: 34, weight: .bold)

        return label
    }()

    private let placeholderView: PlaceholderView = {
        let view = PlaceholderView()

        view.configure(
            image: UIImage(named: "StatisticsPlaceholder"),
            caption: NSLocalizedString("statisticsPlaceholder.caption", comment: "")
        )
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        makeViewLayout()
    }

    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteAdaptive

        view.addSubview(titleLabel)
        view.addSubview(placeholderView)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            placeholderView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
    }
}
