import UIKit

protocol SelectCategoryViewControllerDelegate: AnyObject {
    func didSelect(category title: String)
}

final class SelectCategoryViewController: UIViewController {

    private let checkTable: UITableView = {
        let table = UITableView(frame: .zero)

        table.register(CheckTableViewCell.self, forCellReuseIdentifier: CheckTableViewCell.identifier)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.isScrollEnabled = false

        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16

        return table
    }()

    private let placeholderView: PlaceholderView = {
        let view = PlaceholderView()

        view.configure(
            image: UIImage(named: "CategoriesPlaceholder"),
            caption: "Привычки и события можно\nобъединить по смыслу"
        )
        return view
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)

        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlackDay

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true

        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()

    private let viewModel = CategoryListViewModel()
    private var currentCategoryIndexPath: IndexPath?

    weak var delegate: SelectCategoryViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        checkTable.dataSource = self
        checkTable.delegate = self

        setupNavigationBar()
        makeViewLayout()
        reloadTableData()

        viewModel.$categoryList.bind { [weak self] _ in
            guard let self = self else {
                return
            }
            self.reloadTableData()
        }
    }

    @objc private func didTapAddButton() {
        let createController = CreateCategoryViewController()
        present(UINavigationController(rootViewController: createController), animated: true)
    }

    private func setupNavigationBar() {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlackDay,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.topItem?.title = "Категория"
    }

    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteDay

        view.addSubview(checkTable)
        view.addSubview(placeholderView)
        view.addSubview(addButton)

        checkTable.translatesAutoresizingMaskIntoConstraints = false
        placeholderView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            checkTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            checkTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            checkTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            placeholderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            placeholderView.bottomAnchor.constraint(equalTo: addButton.topAnchor),
            placeholderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            placeholderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
    }

    private func reloadTableData() {
        if viewModel.categoryList.isEmpty {
            placeholderView.isHidden = false
        } else {
            placeholderView.isHidden = true

            let tableHeight = CGFloat(viewModel.categoryList.count * 75)
            checkTable.heightAnchor.constraint(equalToConstant: tableHeight).isActive = true
            checkTable.reloadData()
        }
    }
}

extension SelectCategoryViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categoryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let checkCell = tableView
            .dequeueReusableCell(withIdentifier: CheckTableViewCell.identifier, for: indexPath) as? CheckTableViewCell
            else {
            preconditionFailure("Failed to cast UITableViewCell as CheckTableViewCell")
        }
        checkCell.viewModel = viewModel.categoryList[indexPath.row]

        if indexPath.row == viewModel.categoryList.count - 1 { // hide separator for last cell
            let centerX = checkCell.bounds.width / 2
            checkCell.separatorInset = UIEdgeInsets(top: 0, left: centerX, bottom: 0, right: centerX)
        }
        return checkCell
    }
}

extension SelectCategoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let currentIndexPath = currentCategoryIndexPath {
            tableView.deselectRow(at: currentIndexPath, animated: true)
            viewModel.deselectCategory(at: currentIndexPath.row)
        }
        viewModel.selectCategory(at: indexPath.row)
        currentCategoryIndexPath = indexPath

        delegate?.didSelect(category: viewModel.categoryList[indexPath.row].title)
    }
}
