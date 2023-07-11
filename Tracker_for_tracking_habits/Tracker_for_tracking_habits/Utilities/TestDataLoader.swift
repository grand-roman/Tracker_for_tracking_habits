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
                name: "Догнать по спринтам",
                color: .ypSelection5,
                emoji: "🏃‍",
                schedule: [.monday, .tuesday, .wednesday, .thursday, .friday]
            )
        ]

        let categoryModels = [
            CategoryModel(
                title: "Важное",
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
            entity.id = model.id
            entity.name = model.name
            entity.hexColor = colorSerializer.serialize(color: model.color)
            entity.emoji = model.emoji
            entity.weekDays = scheduleSerializer.serialize(schedule: model.schedule)
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
