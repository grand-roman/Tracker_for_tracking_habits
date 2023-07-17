import Foundation

final class CategoryListViewModel {

    private let categoryStore: CategoryStore
    var currentCategoryTitle: String?

    @Observable
    private(set) var categoryList: Array<CategoryViewModel> = []

    init() {
        categoryStore = CategoryStore()
        categoryStore.delegate = self
        categoryList = fetchCategories()
        guard let currentTitle = currentCategoryTitle,
            let index = self.categoryList.firstIndex(where: { $0.title == currentTitle })
            else {
            return
        }
        self.selectCategory(at: index)
    }

    func selectCategory(at index: Int) {
        let category = categoryList[index]

        categoryList[index] = CategoryViewModel(
            title: category.title,
            isChecked: true
        )
    }

    func deselectCategory(at index: Int) {
        let category = categoryList[index]

        categoryList[index] = CategoryViewModel(
            title: category.title,
            isChecked: false
        )
    }

    func getIndex(at title: String) -> Int? {
        guard let index = self.categoryList.firstIndex(where: { $0.title == title }) else {
            return nil
        }
        return index
    }

    func isPlaceholderHidden() -> Bool {
        return !self.categoryList.isEmpty
    }

    func shouldHideSeparator(at indexPath: IndexPath) -> Bool {
        return indexPath.row == self.categoryList.count - 1
    }

    private func fetchCategories() -> Array<CategoryViewModel> {
        return categoryStore.fetchedCategories.map { model in
            CategoryViewModel(
                title: model.title,
                isChecked: false
            )
        }
    }
}

extension CategoryListViewModel: CategoryStoreDelegate {

    func storeDidChangeCategories() {
        categoryList = fetchCategories()
    }
}
