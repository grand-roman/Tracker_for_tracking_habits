import UIKit

final class OnboardingPageViewController: UIPageViewController {

    private let pageControllers: Array<UIViewController> = {

        let controllerBlue = UIViewController()
        let controllerRed = UIViewController()

        let viewBlue = OnboardingPageView()
        let viewRed = OnboardingPageView()

        viewBlue.configure(
            background: UIImage(named: "OnboardingBackgroundBlue"),
            title: "Отслеживайте только\nто, что хотите"
        )
        viewRed.configure(
            background: UIImage(named: "OnboardingBackgroundRed"),
            title: "Даже если это\nне литры воды и йога"
        )
        controllerBlue.view = viewBlue
        controllerRed.view = viewRed

        return [controllerBlue, controllerRed]
    }()

    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()

        control.numberOfPages = pageControllers.count
        control.currentPage = 0

        control.pageIndicatorTintColor = .ypGray
        control.currentPageIndicatorTintColor = .ypBlackDay

        return control
    }()

    private lazy var nextButton: UIButton = {
        let button = UIButton(type: .custom)

        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlackDay

        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true

        button.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        guard let firstController = pageControllers.first else {
            return
        }
        setViewControllers([firstController], direction: .forward, animated: true)

        makeViewLayout()
    }

    @objc private func didTapNextButton() {
        OnboardingPageStorage.shared.isOnboardingPagePassed = true

        let mainController = MainTabBarController()
        mainController.modalPresentationStyle = .fullScreen
        present(mainController, animated: true)
    }

    private func makeViewLayout() {
        view.addSubview(pageControl)
        view.addSubview(nextButton)

        pageControl.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            nextButton.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 24),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            ])
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {

        guard let currentIndex = pageControllers.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = currentIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }
        return pageControllers[previousIndex]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {

        guard let currentIndex = pageControllers.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = currentIndex + 1

        guard nextIndex < pageControllers.count else {
            return nil
        }
        return pageControllers[nextIndex]
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard completed,
            let currentController = pageViewController.viewControllers?.first,
            let currentIndex = pageControllers.firstIndex(of: currentController)
            else {
            return
        }
        pageControl.currentPage = currentIndex
    }
}
