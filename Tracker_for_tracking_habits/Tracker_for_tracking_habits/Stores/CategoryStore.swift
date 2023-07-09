import UIKit
import CoreData

enum CategoryStoreError: Error {
    case convertTitleError
    case convertTrackerError
    case convertTrackersError
}

protocol CategoryStoreDelegate: AnyObject {
    func storeDidChangeCategories()
}

final class CategoryStore: NSObject {

    private let trackerStore = TrackerStore()
    private let context: NSManagedObjectContext

    private var resultsController: NSFetchedResultsController<CategoryEntity>!

    weak var delegate: CategoryStoreDelegate?

    init(context: NSManagedObjectContext) throws {
        self.context = context
        super.init()

        let request = CategoryEntity.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \CategoryEntity.objectID, ascending: true)
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

    var fetchedCategories: Array<CategoryModel> {
        guard let entities = resultsController.fetchedObjects,
            let models = try? entities.map({ try convert(entity: $0) })
            else {
            return []
        }
        return models
    }

    private func convert(entity: CategoryEntity) throws -> CategoryModel {
        guard let title = entity.title else {
            throw CategoryStoreError.convertTitleError
        }
        guard let trackers = try entity.trackers?.map({ element in
            guard let entity = element as? TrackerEntity else {
                throw CategoryStoreError.convertTrackerError
            }
            return try trackerStore.convert(entity: entity)
        }) else {
            throw CategoryStoreError.convertTrackersError
        }
        return CategoryModel(
            title: title,
            trackers: trackers
        )
    }
}

extension CategoryStore: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.storeDidChangeCategories()
    }
}
