import UIKit

protocol CreateCategoryViewControllerDelegate: AnyObject {
    func didCreate(category title: String)
}

final class CreateCategoryViewController: UIViewController {

    weak var delegate: CreateCategoryViewControllerDelegate?

    private lazy var titleField: CustomTextField = {
        let field = CustomTextField()

        field.placeholder = NSLocalizedString("categoryTitleField.placeholder", comment: "")
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.backgroundColor = .ypBackgroundDay

        field.layer.masksToBounds = true
        field.layer.cornerRadius = 16
        field.heightAnchor.constraint(equalToConstant: 75).isActive = true

        field.addTarget(self, action: #selector(setDoneButtonState), for: .editingChanged)
        return field
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)

        button.setTitle(NSLocalizedString("doneButton.title", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGray
        button.isEnabled = false

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true

        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()

    private let categoryStore = CategoryStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        makeViewLayout()
        hideKeyboardWhenDidTap()
    }

    @objc private func setDoneButtonState() {
        guard let categoryTitle = titleField.text else {
            return
        }
        if categoryTitle.isEmpty {
            doneButton.backgroundColor = .ypGray
            doneButton.isEnabled = false
        } else {
            doneButton.backgroundColor = .ypBlackDay
            doneButton.isEnabled = true
        }
    }

    @objc private func didTapDoneButton() {
        guard let categoryTitle = titleField.text?.trimmingCharacters(in: .whitespaces) else {
            return
        }
        try! categoryStore.addCategory(
            model: CategoryModel(
                title: categoryTitle,
                trackers: []
            )
        )
        delegate?.didCreate(category: categoryTitle)
    }

    private func setupNavigationBar() {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlackDay,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("createCategory.title", comment: "")
    }

    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteDay

        view.addSubview(titleField)
        view.addSubview(doneButton)

        titleField.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
    }
}
