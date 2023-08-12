import UIKit

protocol SelectCategoryViewControllerDelegate: AnyObject {
    func didSelect(category title: String)
}

final class SelectCategoryViewController: UIViewController {

    weak var delegate: SelectCategoryViewControllerDelegate?
    var currentCategoryTitle: String?
    private let viewModel: CategoryListViewModel

    init(as viewModel: CategoryListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let checkTable: UITableView = {
        let table = UITableView(frame: .zero)

        table.register(CheckTableViewCell.self, forCellReuseIdentifier: CheckTableViewCell.identifier)
        table.isScrollEnabled = false

        table.separatorColor = .ypGray
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.tableHeaderView = UIView()

        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16

        return table
    }()

    private let placeholderView: PlaceholderView = {
        let view = PlaceholderView()

        view.configure(
            image: UIImage(named: "CategoriesPlaceholder"),
            caption: NSLocalizedString("categoriesPlaceholder.caption", comment: "")
        )
        return view
    }()

    private lazy var addButton: UIButton = {
        let button = UIButton(type: .custom)

        button.setTitle(NSLocalizedString("addCategoryButton.title", comment: ""), for: .normal)
        button.setTitleColor(.ypWhiteAdaptive, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlackAdaptive

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true

        button.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        return button
    }()

    private lazy var tableHeightConstraint: NSLayoutConstraint = {
        let constraint = checkTable.heightAnchor.constraint(equalToConstant: 0)
        constraint.isActive = true
        return constraint
    }()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard let currentTitle = currentCategoryTitle,
            let index = viewModel.categoryList.firstIndex(where: { $0.title == currentTitle })
            else {
            return
        }
        viewModel.selectCategory(at: index)
    }

    @objc private func didTapAddButton() {
        let createController = CreateCategoryViewController()
        createController.delegate = self
        present(UINavigationController(rootViewController: createController), animated: true)
    }

    private func setupNavigationBar() {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlackAdaptive,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("category.title", comment: "")
    }

    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteAdaptive

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
        placeholderView.isHidden = viewModel.isPlaceholderHidden()
        tableHeightConstraint.constant = CGFloat(viewModel.categoryList.count * 75)
        checkTable.reloadData()
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

        return checkCell
    }
}

extension SelectCategoryViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectCategory(at: indexPath.row)
        delegate?.didSelect(category: viewModel.categoryList[indexPath.row].title)
    }
}

extension SelectCategoryViewController: CreateCategoryViewControllerDelegate {

    func didCreate(category title: String) {
        guard let index = viewModel.categoryList.firstIndex(where: { $0.title == title }) else {
            return
        }
        viewModel.selectCategory(at: index)
        reloadTableData()
        dismiss(animated: true)
    }
}
