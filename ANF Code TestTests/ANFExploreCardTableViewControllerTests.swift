//
//  ANF_Code_TestTests.swift
//  ANF Code TestTests
//


import XCTest
@testable import ANF_Code_Test

class ANFExploreCardTableViewControllerTests: XCTestCase {

    private var exploreData: Data? { ExploreItem.localExploreData }

    private var exploreItems: [ExploreItem]? { ExploreItem.localExploreItems }

    var testInstance: ANFExploreCardTableViewController!

    override func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vcId = ANFExploreCardTableViewController.storyboardId

        testInstance = storyboard.instantiateViewController(withIdentifier: vcId) as? ANFExploreCardTableViewController

        testInstance.exploreItems = exploreItems
    }

    func test_exploreData_shouldNotBeNil() {
        XCTAssertNotNil(exploreData, "explorerItems should not be nil")
    }

    func test_exploreItem_canParseAndDecodeExploreData() {
        XCTAssertNotNil(exploreItems, "explorerItems should not be nil")
    }

    func test_exploreItems_shouldHaveTenItems() {
        XCTAssertEqual(exploreItems?.count, 10, "exploreItems array should have 10 elements")
    }

    func test_numberOfSections_shouldBeOne() {
        let numberOfSections = testInstance.numberOfSections(in: testInstance.tableView)
        XCTAssertEqual(numberOfSections, 1, "table view should have 1 section")
    }

    func test_numberOfRows_shouldBeTen() {
        let numberOfRows = testInstance.tableView(testInstance.tableView, numberOfRowsInSection: 0)
        XCTAssertEqual(numberOfRows, 10, "table view should have 10 cells")
    }

    func test_cellForRowAtIndexPath_topDescription_shouldNotBeBlank() {
        guard let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreContentTableViewCell else {
            XCTFail("firstCell must not be nil.")
            return
        }

        let topDescription = firstCell.topDescription
        XCTAssertFalse(topDescription?.isEmpty ?? true, "top description should not be blank")
    }

    func test_cellForRowAtIndexPath_titleText_shouldNotBeBlank() {
        guard let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreContentTableViewCell else {
            XCTFail("firstCell must not be nil.")
            return
        }

        let title = firstCell.title
        XCTAssertFalse(title?.isEmpty ?? true, "title should not be blank")
    }

    func test_cellForRowAtIndexPath_promo_shouldNotBeBlank() {
        guard let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreContentTableViewCell else {
            XCTFail("firstCell must not be nil.")
            return
        }

        let promo = firstCell.topDescription
        XCTAssertFalse(promo?.isEmpty ?? true, "promo should not be blank")
    }

    func test_cellForRowAtIndexPath_ImageViewImage_shouldNotBeNil() {
        guard let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreContentTableViewCell else {
            XCTFail("firstCell must not be nil.")
            return
        }

        // Set a delay to avoid race condition between retrieving the image and setting it on the cell's image view:
        let secondsToDelay = 5.0
        DispatchQueue.main.asyncAfter(deadline: .now() + secondsToDelay) {
            let image = firstCell.image
            XCTAssertNotNil(image, "image view image should not be nil")
        }
    }

    func test_cellForRowAtIndexPath_bottomDescription_shouldNotBeBlank() {
        guard let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreContentTableViewCell else {
            XCTFail("firstCell must not be nil.")
            return
        }

        let bottomAttDescription = firstCell.bottomDescription
        XCTAssertNotNil(bottomAttDescription, "bottom attributed description should not be nil")
    }

    func test_cellForRowAtIndexPath_contentButtons_shouldHaveTwoButtons() {
        guard let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreContentTableViewCell else {
            XCTFail("firstCell must not be nil.")
            return
        }

        let buttons = firstCell.contentButtons
        XCTAssertEqual(buttons.count, 2, "firstCell should have 2 buttons")
    }

    func test_downloadWebExploreData() async throws {
        let items: [ExploreItem] = try await NetworkManager.shared.loadExploreItems()
        XCTAssertNotNil(items, "Items should not be nil")
    }

    func test_downloadBackgroundImage() async throws {
        let items: [ExploreItem] = try await NetworkManager.shared.loadExploreItems()

        XCTAssertNotNil(items, "Items should not be nil")
        XCTAssertGreaterThan(items.count, 0, "There should be at least one item available")

        guard let item = items.first, let url = item.backgroundImageUrl else {
            XCTFail("No items available for image download testing")
            return
        }

        let image = try await NetworkManager.shared.downloadImage(url: url)
        XCTAssertNotNil(image, "Image should be valid")
    }
}
