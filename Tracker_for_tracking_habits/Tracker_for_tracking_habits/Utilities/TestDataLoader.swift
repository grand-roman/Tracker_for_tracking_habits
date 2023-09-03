import UIKit
import CoreData

final class TestDataLoader {

    static let shared = TestDataLoader()

    private let colorSerializer = UIColorSerializer()
    private let scheduleSerializer = ScheduleSerializer()

    private let context: NSManagedObjectContext = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure("Failed to cast UIApplicationDelegate as AppDelegate")
        }
        return delegate.persistentContainer.viewContext
    }()

    private init() {}

    func loadTestData() {
        let storedCategories = try! context.fetch(CategoryEntity.fetchRequest())

        if storedCategories.count > 0 {
            return
        }

        let testID = UUID()

        let recordModels = [
            RecordModel(
                trackerID: testID,
                completionDate: Date()
            )
        ]

        let trackerModels = [
            TrackerModel(
                id: testID,
                name: NSLocalizedString("testTracker.name", comment: ""),
                color: .ypSelection18,
                emoji: NSLocalizedString("testTracker.emoji", comment: ""),
                schedule: [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday],
                isPinned: false
            )
        ]

        let categoryModels = [
            CategoryModel(
                title: NSLocalizedString("testCategory.title", comment: ""),
                trackers: trackerModels
            )
        ]

        let recordEntities = recordModels.map { model in
            let entity = RecordEntity(context: context)
            entity.trackerID = model.trackerID
            entity.completionDate = model.completionDate
            return entity
        }

        let trackerEntities = trackerModels.map { model in
            let entity = TrackerEntity(context: context)
            entity.trackerID = model.id
            entity.name = model.name
            entity.hexColor = colorSerializer.serialize(color: model.color)
            entity.emoji = model.emoji
            entity.weekDays = scheduleSerializer.serialize(schedule: model.schedule)
            entity.isPinned = model.isPinned
            entity.records = NSSet(array: recordEntities)
            return entity
        }

        _ = categoryModels.map { model in
            let entity = CategoryEntity(context: context)
            entity.title = model.title
            entity.trackers = NSSet(array: trackerEntities)
            return entity
        }

        try! context.save()
    }
}
