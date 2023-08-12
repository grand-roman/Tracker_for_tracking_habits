import UIKit

protocol AddTrackerViewControllerDelegate: AnyObject {
    func didAddNewTracker(model: TrackerModel, to category: String)
}

final class AddTrackerViewController: UIViewController {

    weak var delegate: AddTrackerViewControllerDelegate?

    private lazy var habitButton: UIButton = {
        let button = UIButton(type: .custom)

        button.setTitle(NSLocalizedString("habitButton.title", comment: ""), for: .normal)
        button.setTitleColor(.ypWhiteAdaptive, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlackAdaptive

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true

        button.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        return button
    }()

    private lazy var eventButton: UIButton = {
        let button = UIButton(type: .custom)

        button.setTitle(NSLocalizedString("irregularEventButton.title", comment: ""), for: .normal)
        button.setTitleColor(.ypWhiteAdaptive, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlackAdaptive

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true

        button.addTarget(self, action: #selector(didTapEventButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        makeViewLayout()
    }

    @objc private func didTapHabitButton() {
        let habitController = CreateTrackerViewController()
        habitController.delegate = self
        habitController.isHabitView = true
        present(UINavigationController(rootViewController: habitController), animated: true)
    }

    @objc private func didTapEventButton() {
        let eventController = CreateTrackerViewController()
        eventController.delegate = self
        eventController.isHabitView = false
        present(UINavigationController(rootViewController: eventController), animated: true)
    }

    private func setupNavigationBar() {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlackAdaptive,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("addTracker.title", comment: "")
    }

    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteAdaptive

        let buttonStack = makeButtonStack()

        view.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }

    private func makeButtonStack() -> UIStackView {
        let stack = UIStackView()

        stack.axis = .vertical
        stack.spacing = 16

        stack.addArrangedSubview(habitButton)
        stack.addArrangedSubview(eventButton)

        return stack
    }
}

extension AddTrackerViewController: CreateTrackerViewControllerDelegate {

    func didCreateNewTracker(model: TrackerModel, in category: String) {
        delegate?.didAddNewTracker(model: model, to: category)
    }

    func didCancelNewTracker() {
        dismiss(animated: true)
    }
}
