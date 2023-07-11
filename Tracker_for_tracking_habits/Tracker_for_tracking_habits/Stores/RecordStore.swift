import UIKit
import CoreData

enum RecordStoreError: Error {
    case convertTrackerIDError
    case convertCompletionDateError
}

protocol RecordStoreDelegate: AnyObject {
    func storeDidChangeRecords()
}

final class RecordStore: NSObject {

    weak var delegate: RecordStoreDelegate?

    private let context: NSManagedObjectContext

    private var resultsController: NSFetchedResultsController<RecordEntity>!

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let request = RecordEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \RecordEntity.objectID, ascending: true)
        ]
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self

        resultsController = controller
        try resultsController.performFetch()
    }

    convenience override init() {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            preconditionFailure("Failed to cast UIApplicationDelegate as AppDelegate")
        }
        try! self.init(context: delegate.persistentContainer.viewContext)
    }

    var fetchedRecords: Array<RecordModel> {
        guard let entities = resultsController.fetchedObjects,
            let models = try? entities.map({ try convert(entity: $0) })
            else {
            return []
        }
        return models
    }

    func addRecord(model: RecordModel) throws {
        try updateRecord(entity: RecordEntity(context: context), using: model)
        try context.save()
    }

    func updateRecord(entity: RecordEntity, using model: RecordModel) throws {
        entity.trackerID = model.trackerID
        entity.completionDate = model.completionDate
        entity.tracker = try fetchTracker(by: model.trackerID)
    }

    func deleteRecord(model: RecordModel) throws {
        context.delete(try fetchRecord(using: model))
        try context.save()
    }

    private func convert(entity: RecordEntity) throws -> RecordModel {
        guard let trackerID = entity.trackerID else {
            throw RecordStoreError.convertTrackerIDError
        }
        guard let completionDate = entity.completionDate else {
            throw RecordStoreError.convertCompletionDateError
        }
        return RecordModel(
            trackerID: trackerID,
            completionDate: completionDate
        )
    }

    private func fetchTracker(by id: UUID) throws -> TrackerEntity {
        let request = NSFetchRequest<TrackerEntity>(entityName: "TrackerEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try context.fetch(request)[0]
    }

    private func fetchRecord(using model: RecordModel) throws -> RecordEntity {
        let request = NSFetchRequest<RecordEntity>(entityName: "RecordEntity")
        request.predicate = NSPredicate(
            format: "%K == %@ AND %K == %@",
            #keyPath(RecordEntity.trackerID), model.trackerID as CVarArg,
            #keyPath(RecordEntity.completionDate), model.completionDate as CVarArg
        )
        return try context.fetch(request)[0]
    }
}

extension RecordStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidChangeRecords()
    }
}
