import UIKit

final class MockData {
    static var categories: [TrackerCategory] = [
        TrackerCategory(nameCategory: "Важное", trackers: [
            Tracker(id: UUID(), name: "Не забывать жить, не только кодить", emoji: "🤡", color: .YPBlue, schedule: [.wednesday, .saturday]),
            Tracker(id: UUID(), name: "Догнать по спринтам", emoji: "🏃‍♂️", color: .YPRed, schedule: [.monday, .saturday, .wednesday, .friday, .sunday, .thursday, .tuesday])
            ]),
        TrackerCategory(nameCategory: "ЯП", trackers: [
            Tracker(id: UUID(), name: "14 спринт", emoji: "😤", color: .YPBlue, schedule: [.monday, .wednesday, .friday]),
            Tracker(id: UUID(), name: "15 спринт", emoji: "😤", color: .CS07, schedule: [.monday, .wednesday, .saturday]),
            Tracker(id: UUID(), name: "16 спринт", emoji: "🥲", color: .CS11, schedule: [.tuesday, .thursday, .saturday]),
            Tracker(id: UUID(), name: "17 спринт", emoji: "😭", color: .CS12, schedule: [.wednesday, .saturday]),
            ])]
}
