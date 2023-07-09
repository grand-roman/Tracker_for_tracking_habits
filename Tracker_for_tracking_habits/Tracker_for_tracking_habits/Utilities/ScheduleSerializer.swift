import Foundation

final class ScheduleSerializer {

    func serialize(schedule: Set<WeekDay>) -> Int32 {
        let values = schedule.map { weekDay in
            weekDay.rawValue
        }
        return Int32(
            values.reduce(0) { result, next in
                result * 10 + next
            }
        )
    }

    func deserialize(days: Int32) -> Set<WeekDay> {
        let values = String(days).compactMap { element in
            Int(String(element))
        }
        return Set(
            values.compactMap { value in
                WeekDay(rawValue: value)
            }
        )
    }
}
