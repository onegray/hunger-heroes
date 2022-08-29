//
// Created by onegray on 29.08.22.
//

import Foundation

extension Date {

    static var iso8601Formatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    func iso8601String() -> String {
        return Date.iso8601Formatter.string(from: self)
    }

    static func fromIso8601String(_ dateStr: String?) -> Date? {
        return dateStr != nil ? Date.iso8601Formatter.date(from: dateStr!) : nil
    }
}
