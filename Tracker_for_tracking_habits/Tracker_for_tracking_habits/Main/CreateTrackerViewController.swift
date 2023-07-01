import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func createTracker(_ tracker: Tracker, categoryName: String)
}

class CreateTrackerViewController: UIViewController {
    
    public weak var delegate: CreateTrackerViewControllerDelegate?
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Создание трекера"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var createRegularEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.backgroundColor = .YPBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(regularEventButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var createIrregularEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.backgroundColor = .YPBlack
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(irregularEventButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubviews()
        setupLayout()
    }
    
    @objc private func irregularEventButtonAction() {
        let createEvent = CreateEventViewController(.irregular)
        createEvent.delegate = self
        present(createEvent, animated: true)
    }
    
    @objc private func regularEventButtonAction() {
        let createEvent = CreateEventViewController(.regular)
        createEvent.delegate = self
        present(createEvent, animated: true)
    }
    
    private func addSubviews() {
        view.addSubview(label)
        view.addSubview(createRegularEventButton)
        view.addSubview(createIrregularEventButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            createRegularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createRegularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createRegularEventButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 295),
            createRegularEventButton.widthAnchor.constraint(equalToConstant: 335),
            createRegularEventButton.heightAnchor.constraint(equalToConstant: 60),
            
            createIrregularEventButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createIrregularEventButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createIrregularEventButton.topAnchor.constraint(equalTo: createRegularEventButton.bottomAnchor, constant: 16),
            createIrregularEventButton.widthAnchor.constraint(equalToConstant: 335),
            createIrregularEventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension CreateTrackerViewController: CreateEventViewControllerDelegate {
    
    func createTracker(_ tracker: Tracker, categoryName: String) {
        delegate?.createTracker(tracker, categoryName: categoryName)
        dismiss(animated: true)
    }
}
