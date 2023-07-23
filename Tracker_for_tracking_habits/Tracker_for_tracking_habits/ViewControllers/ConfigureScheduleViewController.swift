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
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        table.tableHeaderView = UIView() // remove separator above first cell
        table.isScrollEnabled = false
        table.allowsSelection = false

        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        table.heightAnchor.constraint(equalToConstant: 525).isActive = true

        return table
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)

        button.setTitle("Готово", for: .normal)
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
            SwitchOptions(weekDay: .monday, name: "Понедельник", isOn: currentSchedule.contains(.monday)),
            SwitchOptions(weekDay: .tuesday, name: "Вторник", isOn: currentSchedule.contains(.tuesday)),
            SwitchOptions(weekDay: .wednesday, name: "Среда", isOn: currentSchedule.contains(.wednesday)),
            SwitchOptions(weekDay: .thursday, name: "Четверг", isOn: currentSchedule.contains(.thursday)),
            SwitchOptions(weekDay: .friday, name: "Пятница", isOn: currentSchedule.contains(.friday)),
            SwitchOptions(weekDay: .saturday, name: "Суббота", isOn: currentSchedule.contains(.saturday)),
            SwitchOptions(weekDay: .sunday, name: "Воскресенье", isOn: currentSchedule.contains(.sunday))
            ])
    }

    private func setupNavigationBar() {
        let titleAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.ypBlackDay,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)
        ]
        navigationController?.navigationBar.titleTextAttributes = titleAttributes
        navigationController?.navigationBar.topItem?.title = "Расписание"
    }

    private func makeViewLayout() {
        view.backgroundColor = .ypWhiteDay

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
            doneButton.backgroundColor = .ypGray
            doneButton.isEnabled = false
        } else {
            doneButton.backgroundColor = .ypBlackDay
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

        if indexPath.row == switches.count - 1 { // hide separator for last cell
            let centerX = switchCell.bounds.width / 2
            switchCell.separatorInset = UIEdgeInsets(top: 0, left: centerX, bottom: 0, right: centerX)
        }
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
