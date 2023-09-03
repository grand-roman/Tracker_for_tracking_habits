import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func didCreateNewTracker(model: TrackerModel, in category: String)
    func didCancelNewTracker()
}

class CreateTrackerViewController: UIViewController {

    weak var delegate: CreateTrackerViewControllerDelegate?
    var isHabitView: Bool = true

    fileprivate lazy var nameField: CustomTextField = {
        let field = CustomTextField()

        field.placeholder = NSLocalizedString("trackerNameField.placeholder", comment: "")
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.backgroundColor = .ypBackgroundAdaptive

        field.layer.masksToBounds = true
        field.layer.cornerRadius = 16
        field.heightAnchor.constraint(equalToConstant: 75).isActive = true

        field.addTarget(self, action: #selector(setCreateButtonState), for: .editingChanged)
        return field
    }()

    private let settingTable: UITableView = {
        let table = UITableView(frame: .zero)

        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.isScrollEnabled = false

        table.separatorColor = .ypGray
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16

        return table
    }()

    fileprivate let emojiColorCollection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.allowsMultipleSelection = true

        collection.register(
            EmojiCollectionViewCell.self,
            forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier
        )
        collection.register(
            ColorCollectionViewCell.self,
            forCellWithReuseIdentifier: ColorCollectionViewCell.identifier
        )
        collection.register(
            CollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CollectionViewHeader.identifier
        )
        return collection
    }()

    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .custom)

        button.setTitle(NSLocalizedString("cancelButton.title", comment: ""), for: .normal)
        button.setTitleColor(.ypRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.ypRed.cgColor

        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }()

    fileprivate lazy var createButton: UIButton = {
        let button = UIButton(type: .custom)

        button.setTitle(NSLocalizedString("createButton.title", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGray
        button.isEnabled = false

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16

        button.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        return button
    }()

    private let widthParameters = CollectionWidthParameters(cellsNumber: 6, leftInset: 20, rightInset: 20, interCellSpacing: 10)

    fileprivate let emojis: Array<String> = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]

    fileprivate let colors: Array<UIColor> = [
        .ypSelection1, .ypSelection2, .ypSelection3, .ypSelection4, .ypSelection5, .ypSelection6,
        .ypSelection7, .ypSelection8, .ypSelection9, .ypSelection10, .ypSelection11, .ypSelection12,
        .ypSelection13, .ypSelection14, .ypSelection15, .ypSelection16, .ypSelection17, .ypSelection18
    ]

    private var settings: Array<SettingOptions> = []
    fileprivate var selectedCategoryTitle: String?
    fileprivate var configuredSchedule: Set<WeekDay> = []

    fileprivate var currentEmojiIndexPath: IndexPath?
    fileprivate var currentColorIndexPath: IndexPath?


    override func viewDidLoad() {
        super.viewDidLoad()

        settingTable.dataSource = self
        settingTable.delegate = self

        emojiColorCollection.dataSource = self
        emojiColorCollection.delegate = self

        setupNavigationBar()
        makeViewLayout()
        customizeView()
        hideKeyboardWhenDidTap()
    }

    @objc private func setCreateButtonState() {
        guard let trackerName = nameField.text else {
            return
        }
        if trackerName.isEmpty
            || selectedCategoryTitle == nil
            || configuredSchedule.isEmpty && isHabitView
            || currentEmojiIndexPath == nil
            || currentColorIndexPath == nil
        {
            createButton.setTitleColor(.ypWhite, for: .normal)
            createButton.backgroundColor = .ypGray
            createButton.isEnabled = false
        } else {
            createButton.setTitleColor(.ypWhiteAdaptive, for: .normal)
            createButton.backgroundColor = .ypBlackAdaptive
            createButton.isEnabled = true
        }
    }

    @objc fileprivate func didTapCancelButton() {
        delegate?.didCancelNewTracker()
    }

    @objc fileprivate func didTapCreateButton() {
        guard let trackerName = nameField.text,
              let categoryTitle = selectedCategoryTitle
        else {
            return
        }
        let tracker = TrackerModel(
            id: UUID(),
            name: trackerName.trimmingCharacters(in: .whitespaces),
            color: colors[currentColorIndexPath?.item ?? 0],
            emoji: emojis[currentEmojiIndexPath?.item ?? 0],
            schedule: configuredSchedule,
            isPinned: false
        )
        delegate?.didCreateNewTracker(model: tracker, in: categoryTitle)
    }

    private func setupNavigationBar() {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlackAdaptive,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("createHabit.title", comment: "")
    }

    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteAdaptive

        let scrollView = UIScrollView()
        let mainStack = makeMainStack()

        view.addSubview(scrollView)
        scrollView.addSubview(mainStack)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        mainStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            mainStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 24),
            mainStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            mainStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor)
        ])

        view.layoutIfNeeded()
        let contentHeight = emojiColorCollection.collectionViewLayout.collectionViewContentSize.height
        emojiColorCollection.heightAnchor.constraint(equalToConstant: contentHeight).isActive = true
    }

    private func makeMainStack() -> UIStackView {
        let mainStack = UIStackView()
        let buttonStack = makeButtonStack()

        mainStack.axis = .vertical
        mainStack.alignment = .center

        mainStack.addArrangedSubview(nameField)
        mainStack.addArrangedSubview(settingTable)
        mainStack.addArrangedSubview(emojiColorCollection)
        mainStack.addArrangedSubview(buttonStack)

        mainStack.setCustomSpacing(24, after: nameField)
        mainStack.setCustomSpacing(32, after: settingTable)

        NSLayoutConstraint.activate([
            nameField.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -16),

            settingTable.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 16),
            settingTable.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -16),

            emojiColorCollection.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            emojiColorCollection.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),

            buttonStack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor, constant: -20)
        ])
        return mainStack
    }

    private func makeButtonStack() -> UIStackView {
        let stack = UIStackView()

        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 10
        stack.heightAnchor.constraint(equalToConstant: 60).isActive = true

        stack.addArrangedSubview(cancelButton)
        stack.addArrangedSubview(createButton)

        return stack
    }

    private func customizeView() {
        settings.append(
            SettingOptions(
                name: NSLocalizedString("category.title", comment: ""),
                handler: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.didTapSettingCategory()
                }
            )
        )
        if isHabitView {
            settings.append(
                SettingOptions(
                    name: NSLocalizedString("schedule.title", comment: ""),
                    handler: { [weak self] in
                        guard let self = self else {
                            return
                        }
                        self.didTapSettingSchedule()
                    }
                )
            )
        } else {
            navigationController?.navigationBar.topItem?.title = NSLocalizedString("createIrregularEvent.title", comment: "")
        }
        settingTable.heightAnchor.constraint(equalToConstant: CGFloat(settings.count * 75)).isActive = true
        settingTable.reloadData()
    }

    private func didTapSettingCategory() {
        let viewModel = CategoryListViewModel()
        viewModel.currentCategoryTitle = selectedCategoryTitle
        let categoryController = SelectCategoryViewController(as: viewModel)
        categoryController.delegate = self
        present(UINavigationController(rootViewController: categoryController), animated: true)
    }

    private func didTapSettingSchedule() {
        let scheduleController = ConfigureScheduleViewController()
        scheduleController.delegate = self
        scheduleController.currentSchedule = configuredSchedule
        present(UINavigationController(rootViewController: scheduleController), animated: true)
    }

    fileprivate func configureSettingCell(caption text: String, at index: Int) {
        guard let settingCell = settingTable
            .cellForRow(at: IndexPath(row: index, section: 0)) as? SettingTableViewCell
        else {
            preconditionFailure("Failed to cast UITableViewCell as SettingTableViewCell")
        }
        settingCell.configure(caption: text)
        settingTable.reloadData()
    }
}

extension CreateTrackerViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let settingCell = tableView
            .dequeueReusableCell(withIdentifier: SettingTableViewCell.identifier, for: indexPath) as? SettingTableViewCell
        else {
            preconditionFailure("Failed to cast UITableViewCell as SettingTableViewCell")
        }
        settingCell.configure(options: settings[indexPath.row])

        return settingCell
    }
}

extension CreateTrackerViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        settings[indexPath.row].handler()
    }
}

extension CreateTrackerViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return emojis.count
        case 1:
            return colors.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let emojiCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: EmojiCollectionViewCell.identifier, for: indexPath) as? EmojiCollectionViewCell
            else {
                preconditionFailure("Failed to cast UICollectionViewCell as EmojiCollectionViewCell")
            }
            emojiCell.configure(emoji: emojis[indexPath.item])
            return emojiCell
        case 1:
            guard let colorCell = collectionView
                .dequeueReusableCell(withReuseIdentifier: ColorCollectionViewCell.identifier, for: indexPath) as? ColorCollectionViewCell
            else {
                preconditionFailure("Failed to cast UICollectionViewCell as ColorCollectionViewCell")
            }
            colorCell.configure(color: colors[indexPath.item])
            return colorCell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewHeader.identifier, for: indexPath) as? CollectionViewHeader
        else {
            preconditionFailure("Failed to cast UICollectionReusableView as CollectionViewHeader")
        }
        switch indexPath.section {
        case 0:
            header.configure(title: NSLocalizedString("emoji.title", comment: ""))
        case 1:
            header.configure(title: NSLocalizedString("color.title", comment: ""))
        default:
            return UICollectionReusableView()
        }
        return header
    }
}

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - widthParameters.widthInsets
        let cellWidth = availableWidth / CGFloat(widthParameters.cellsNumber)
        return CGSize(width: cellWidth, height: 52)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: widthParameters.leftInset, bottom: 40, right: widthParameters.rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        let targetSize = CGSize(width: collectionView.bounds.width, height: 18)

        return headerView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .required)
    }
}

extension CreateTrackerViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            if let currentIndexPath = currentEmojiIndexPath {
                emojiColorCollection.deselectItem(at: currentIndexPath, animated: true)
                (collectionView.cellForItem(at: currentIndexPath) as? EmojiCollectionViewCell)?.deselectEmoji()
            }
            (collectionView.cellForItem(at: indexPath) as? EmojiCollectionViewCell)?.selectEmoji()
            currentEmojiIndexPath = indexPath
        case 1:
            if let currentIndexPath = currentColorIndexPath {
                emojiColorCollection.deselectItem(at: currentIndexPath, animated: true)
                (collectionView.cellForItem(at: currentIndexPath) as? ColorCollectionViewCell)?.deselectColor()
            }
            (collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell)?.selectColor()
            currentColorIndexPath = indexPath
        default:
            return
        }
        setCreateButtonState()
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        emojiColorCollection.selectItem(at: indexPath, animated: false, scrollPosition: .top)
    }
}

extension CreateTrackerViewController: SelectCategoryViewControllerDelegate {

    func didSelect(category title: String) {
        configureSettingCell(caption: title, at: 0)
        setCreateButtonState()
        selectedCategoryTitle = title
        dismiss(animated: true)
    }
}

extension CreateTrackerViewController: ConfigureScheduleViewControllerDelegate {

    func didConfigure(schedule: Set<WeekDay>) {
        configureSettingCell(caption: makeCaption(from: schedule), at: 1)
        setCreateButtonState()
        configuredSchedule = schedule
        dismiss(animated: true)
    }

    fileprivate func makeCaption(from schedule: Set<WeekDay>) -> String {
        if schedule.count == 7 {
            return NSLocalizedString("weekDay.all", comment: "")
        }
        let weekDays = schedule.sorted { $0.rawValue < $1.rawValue }
        var names: Array<String> = []

        for day in weekDays {
            switch day {
            case .monday:
                names.append(NSLocalizedString("monday.short", comment: ""))
            case .tuesday:
                names.append(NSLocalizedString("tuesday.short", comment: ""))
            case .wednesday:
                names.append(NSLocalizedString("wednesday.short", comment: ""))
            case .thursday:
                names.append(NSLocalizedString("thursday.short", comment: ""))
            case .friday:
                names.append(NSLocalizedString("friday.short", comment: ""))
            case .saturday:
                names.append(NSLocalizedString("saturday.short", comment: ""))
            case .sunday:
                names.append(NSLocalizedString("sunday.short", comment: ""))
            }
        }
        return names.joined(separator: NSLocalizedString("weekDay.separator", comment: ""))
    }
}

protocol EditTrackerViewControllerDelegate: AnyObject {
    func didSaveEditedTracker(model: TrackerModel, in category: String)
    func didCancelEditTracker()
}

class EditTrackerViewController: CreateTrackerViewController {

    private let colorSerializer = UIColorSerializer()

    private var trackerID: UUID?
    private var eventDate: Date?
    private var isPinned: Bool?

    weak var editDelegate: EditTrackerViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        customizeEditView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        configureSettingCell(caption: selectedCategoryTitle ?? "", at: 0)
        if isHabitView {
            configureSettingCell(caption: makeCaption(from: configuredSchedule), at: 1)
        }
        collectionView(emojiColorCollection, didSelectItemAt: currentEmojiIndexPath ?? IndexPath(item: 0, section: 0))
        collectionView(emojiColorCollection, didSelectItemAt: currentColorIndexPath ?? IndexPath(item: 0, section: 1))
    }

    override func didTapCancelButton() {
        editDelegate?.didCancelEditTracker()
    }

    override func didTapCreateButton() {
        guard let trackerName = nameField.text,
              let categoryTitle = selectedCategoryTitle
        else {
            return
        }
        let tracker = TrackerModel(
            id: trackerID ?? UUID(),
            name: trackerName.trimmingCharacters(in: .whitespaces),
            color: colors[currentColorIndexPath?.item ?? 0],
            emoji: emojis[currentEmojiIndexPath?.item ?? 0],
            schedule: configuredSchedule,
            date: eventDate,
            isPinned: isPinned ?? false
        )
        editDelegate?.didSaveEditedTracker(model: tracker, in: categoryTitle)
    }

    func setTrackerToEdit(model: TrackerModel, in category: String) {
        trackerID = model.id
        eventDate = model.date
        isPinned = model.isPinned

        nameField.text = model.name
        selectedCategoryTitle = category
        configuredSchedule = model.schedule

        let emojIndex = emojis.firstIndex(where: { $0 == model.emoji }) ?? 0
        currentEmojiIndexPath = IndexPath(item: emojIndex, section: 0)

        let hexColors = colors.map({ colorSerializer.serialize(color: $0) })
        let modelColor = colorSerializer.serialize(color: model.color)
        let colorIndex = hexColors.firstIndex(where: { $0 == modelColor }) ?? 0
        currentColorIndexPath = IndexPath(item: colorIndex, section: 1)
    }

    private func customizeEditView() {
        let titleKey = isHabitView ? "editHabit.title" : "editIrregularEvent.title"
        navigationController?.navigationBar.topItem?.title = NSLocalizedString(titleKey, comment: "")
        createButton.setTitle(NSLocalizedString("saveButton.title", comment: ""), for: .normal)
    }
}
