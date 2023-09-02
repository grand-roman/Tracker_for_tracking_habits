import XCTest
import SnapshotTesting

@testable import Tracker_for_tracking_habits

final class MainTabBarControllerTestCase: XCTestCase {
    
    func testSnapshotMatch() {
        assertSnapshot(matching: MainTabBarController(), as: .image)
    }
}
