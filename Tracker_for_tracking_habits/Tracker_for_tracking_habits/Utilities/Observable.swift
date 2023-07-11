import Foundation

@propertyWrapper
final class Observable<ValueType> {

    var wrappedValue: ValueType {
        didSet {
            onChange?(wrappedValue)
        }
    }

    var projectedValue: Observable<ValueType> {
        return self
    }

    private var onChange: ((ValueType) -> Void)?

    init(wrappedValue: ValueType) {
        self.wrappedValue = wrappedValue
    }

    func bind(action: @escaping (ValueType) -> Void) {
        self.onChange = action
    }
}
