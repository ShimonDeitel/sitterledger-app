import Foundation

struct Session: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var familyName: String
    var hours: Double
    var rate: Double
    var sessionDate: Date
    var notes: String

    init(id: UUID = UUID(), familyName: String = "", hours: Double = 0.0, rate: Double = 0.0, sessionDate: Date = Date(), notes: String = "") {
        self.id = id
        self.familyName = familyName
        self.hours = hours
        self.rate = rate
        self.sessionDate = sessionDate
        self.notes = notes
    }
}
