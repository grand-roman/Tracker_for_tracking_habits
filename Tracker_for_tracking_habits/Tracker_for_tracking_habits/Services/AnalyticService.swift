import YandexMobileMetrica

final class AnalyticService {

    static let shared = AnalyticService()

    private let apiKey = "534eed17-fff0-4b8e-89bb-f2ce0c212a04"

    private init() { }

    func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: apiKey) else {
            print("Failed to activate")
            return
        }
        print("Activate done!!!!!!!!!!!!!!!!!!!!!!!!!!")
        YMMYandexMetrica.activate(with: configuration)
    }

    func report(event name: String, with parameters: Dictionary<AnyHashable, Any>) {
        YMMYandexMetrica.reportEvent(name, parameters: parameters) { error in
            print("Failed to report event \(name) with \(error)")
        }
    }
}
