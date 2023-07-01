import UIKit

final class Storage {
    
    static let shared = Storage()
    private let uniqueId = UUID()
    var trackers: [Tracker] = []
    var storageTrackerCategory: [TrackerCategory] = []
    
    func addNewTracker(name: String, emoji: String, color: UIColor, schedule: [DayOfWeek], category: String) {
        
        let newTracker = Tracker(id: uniqueId, name: name, emoji: emoji, color: color, schedule: schedule)
        if storageTrackerCategory.isEmpty {
            
            trackers.append(newTracker)
            let newTrackerType = TrackerCategory(nameCategory: "Важное", trackers: trackers)
            storageTrackerCategory.append(newTrackerType)
        } else {
            storageTrackerCategory.removeLast()
            
            trackers.append(newTracker)
            let newTrackerType = TrackerCategory(nameCategory: "Важное", trackers: trackers)
            storageTrackerCategory.append(newTrackerType)
        }
    }
}
