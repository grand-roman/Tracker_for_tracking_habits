import UIKit

final class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.tabBarBorderColor.cgColor

        setupTabBarItems()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        tabBar.layer.borderColor = UIColor.tabBarBorderColor.cgColor
    }

    private func setupTabBarItems() {
        let trackersController = UINavigationController(rootViewController: TrackersViewController())
        let statisticsController = UINavigationController(rootViewController: StatisticsViewController())

        trackersController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("trackers.title", comment: ""),
            image: UIImage(named: "TrackersTab"),
            tag: 0
        )
        statisticsController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("statistics.title", comment: ""),
            image: UIImage(named: "StatisticsTab"),
            tag: 1
        )
        viewControllers = [trackersController, statisticsController]
    }
}
