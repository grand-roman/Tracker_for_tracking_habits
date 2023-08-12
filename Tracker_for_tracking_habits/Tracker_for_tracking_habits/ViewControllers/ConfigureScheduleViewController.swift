import UIKit

protocol ConfigureScheduleViewControllerDelegate: AnyObject {
    func didConfigure(schedule: Set<WeekDay>)
}

final class ConfigureScheduleViewController: UIViewController {
    weak var delegate: ConfigureScheduleViewControllerDelegate?
    var currentSchedule: Set<WeekDay> = []

    private let switchTable: UITableView = {
        let table = UITableView(frame: .zero)

        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        table.isScrollEnabled = false
        table.allowsSelection = false

        table.separatorColor = .ypGray
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.tableHeaderView = UIView()

        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        table.heightAnchor.constraint(equalToConstant: 525).isActive = true

        return table
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)

        button.setTitle(NSLocalizedString("doneButton.title", comment: ""), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true

        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()

    private var switches: Array<SwitchOptions> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        switchTable.dataSource = self

        appendSwitches()
        setupNavigationBar()
        makeViewLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setDoneButtonState()
    }

    @objc private func didTapDoneButton() {
        delegate?.didConfigure(schedule: currentSchedule)
    }

    private func appendSwitches() {
        switches.append(contentsOf: [
            SwitchOptions(weekDay: .monday, name: NSLocalizedString("monday.full", comment: ""), isOn: currentSchedule.contains(.monday)),
            SwitchOptions(weekDay: .tuesday, name: NSLocalizedString("tuesday.full", comment: ""), isOn: currentSchedule.contains(.tuesday)),
            SwitchOptions(weekDay: .wednesday, name: NSLocalizedString("wednesday.full", comment: ""), isOn: currentSchedule.contains(.wednesday)),
            SwitchOptions(weekDay: .thursday, name: NSLocalizedString("thursday.full", comment: ""), isOn: currentSchedule.contains(.thursday)),
            SwitchOptions(weekDay: .friday, name: NSLocalizedString("friday.full", comment: ""), isOn: currentSchedule.contains(.friday)),
            SwitchOptions(weekDay: .saturday, name: NSLocalizedString("saturday.full", comment: ""), isOn: currentSchedule.contains(.saturday)),
            SwitchOptions(weekDay: .sunday, name: NSLocalizedString("sunday.full", comment: ""), isOn: currentSchedule.contains(.sunday))
            ])
    }

    private func setupNavigationBar() {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlackAdaptive,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.topItem?.title = NSLocalizedString("schedule.title", comment: "")
    }

    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteAdaptive

        view.addSubview(switchTable)
        view.addSubview(doneButton)

        switchTable.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            switchTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            switchTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            switchTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
    }

    private func setDoneButtonState() {
        if currentSchedule.isEmpty {
            doneButton.setTitleColor(.ypWhite, for: .normal)
            doneButton.backgroundColor = .ypGray
            doneButton.isEnabled = false
        } else {
            doneButton.setTitleColor(.ypWhiteAdaptive, for: .normal)
            doneButton.backgroundColor = .ypBlackAdaptive
            doneButton.isEnabled = true
        }
    }
}

extension ConfigureScheduleViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return switches.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let switchCell = tableView
            .dequeueReusableCell(withIdentifier: SwitchTableViewCell.identifier, for: indexPath) as? SwitchTableViewCell
            else {
            preconditionFailure("Failed to cast UITableViewCell as SwitchTableViewCell")
        }
        switchCell.delegate = self
        switchCell.configure(options: switches[indexPath.row])

        return switchCell
    }
}

extension ConfigureScheduleViewController: SwitchTableViewCellDelegate {

    func didChangeState(isOn: Bool, for weekDay: WeekDay) {
        if isOn {
            currentSchedule.insert(weekDay)
        } else {
            currentSchedule.remove(weekDay)
        }
        setDoneButtonState()
    }
}
