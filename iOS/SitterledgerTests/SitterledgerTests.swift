import XCTest
@testable import Sitterledger

@MainActor
final class SitterledgerTests: XCTestCase {
    func makeIsolatedStore() -> Store {
        Store()
    }

    func testSeedDataUnderFreeLimit() {
        let store = makeIsolatedStore()
        XCTAssertLessThan(Store.seedData().count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = makeIsolatedStore()
        let before = store.items.count
        let added = store.add(Session())
        XCTAssertTrue(added)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteRemovesItem() {
        let store = makeIsolatedStore()
        let item = Session()
        store.add(item)
        store.delete(item)
        XCTAssertFalse(store.items.contains(item))
    }

    func testCanAddMoreWhenUnderLimit() {
        let store = makeIsolatedStore()
        store.items = []
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtLimitWhenNotPro() {
        let store = makeIsolatedStore()
        store.isPro = false
        store.items = Array(repeating: Session(), count: Store.freeLimit)
        XCTAssertFalse(store.canAddMore)
        XCTAssertFalse(store.add(Session()))
    }

    func testProBypassesLimit() {
        let store = makeIsolatedStore()
        store.isPro = true
        store.items = Array(repeating: Session(), count: Store.freeLimit)
        XCTAssertTrue(store.canAddMore)
        XCTAssertTrue(store.add(Session()))
    }

    func testUpdateModifiesExistingItem() {
        let store = makeIsolatedStore()
        var item = Session()
        store.add(item)
        item.familyName = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.familyName, "Updated")
    }

    func testDeleteAtOffsets() {
        let store = makeIsolatedStore()
        store.items = [Session(), Session()]
        store.delete(at: IndexSet(integer: 0))
        XCTAssertEqual(store.items.count, 1)
    }
}
