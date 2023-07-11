import Foundation

final class CategoryListViewModel {

    private let categoryStore = CategoryStore()

    @Observable
    private(set) var categoryList: Array<CategoryViewModel> = []

    init() {
        categoryStore.delegate = self
        categoryList = fetchCategories()
    }

    func selectCategory(at index: Int) {
        categoryList[index].isChecked = true
    }

    func deselectCategory(at index: Int) {
        categoryList[index].isChecked = false
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
