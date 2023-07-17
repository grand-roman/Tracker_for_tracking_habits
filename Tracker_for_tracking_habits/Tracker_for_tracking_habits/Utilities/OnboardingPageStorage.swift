import Foundation

final class OnboardingPageStorage {

    static let shared = OnboardingPageStorage()

    private let storage = UserDefaults.standard

    var isOnboardingPagePassed: Bool {
        get {
            return storage.bool(forKey: Keys.isOnboardingPagePassed.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.isOnboardingPagePassed.rawValue)
        }
    }

    private init() {}
}

private enum Keys: String {
    case isOnboardingPagePassed
}
