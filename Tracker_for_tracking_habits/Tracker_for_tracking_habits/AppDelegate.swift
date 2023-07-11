import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                preconditionFailure("Failed to load persistent stores with \(error)")
            }
        }
        return container
    }()

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow()

        if OnboardingPageStorage.shared.isOnboardingPagePassed {
            window?.rootViewController = MainTabBarController()
        } else {
            window?.rootViewController = OnboardingPageViewController(
                transitionStyle: .scroll,
                navigationOrientation: .horizontal
            )
        }
        window?.makeKeyAndVisible()

        return true
    }
}
