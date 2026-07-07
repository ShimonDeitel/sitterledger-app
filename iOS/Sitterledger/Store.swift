import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [Session] = []
    @Published var isPro: Bool = false

    /// Free tier allows this many entries. Seed data below is always fewer than this
    /// so a fresh install never opens straight into the paywall.
    static let freeLimit = 20

    private let fileName = "sitterledger_items.json"

    private var fileURL: URL {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        if !FileManager.default.fileExists(atPath: dir.path) {
            try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir.appendingPathComponent(fileName)
    }

    init() {
        load()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Session].self, from: data) else {
            items = Self.seedData()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    var canAddMore: Bool {
        isPro || items.count < Self.freeLimit
    }

    @discardableResult
    func add(_ item: Session) -> Bool {
        guard canAddMore else { return false }
        items.append(item)
        save()
        return true
    }

    func update(_ item: Session) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Session) {
        items.removeAll { $0.id == item.id }
        save()
    }

    static func seedData() -> [Session] {
        [
        Session(familyName: "The Johnsons", hours: 3.5, rate: 3.5, sessionDate: Date().addingTimeInterval(-259200), notes: ""),
        Session(familyName: "The Lees", hours: 5.75, rate: 5.75, sessionDate: Date().addingTimeInterval(-518400), notes: "Weekly run"),
        Session(familyName: "The Johnsons", hours: 8.0, rate: 8.0, sessionDate: Date().addingTimeInterval(-777600), notes: ""),
        Session(familyName: "The Lees", hours: 10.25, rate: 10.25, sessionDate: Date().addingTimeInterval(-1036800), notes: "Weekly run")
        ]
    }
}
