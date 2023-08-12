import XCTest
import SnapshotTesting

@testable import Tracker

final class MainTabBarControllerTestCase: XCTestCase {
    
    func testSnapshotMatch() {
        assertSnapshot(matching: MainTabBarController(), as: .image)
    }
}
