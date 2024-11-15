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

    func test_cellForRowAtIndexPath_titleText_shouldNotBeBlank() {
        guard let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreContentTableViewCell else {
            XCTFail("firstCell must not be nil.")
            return
        }

        let title = firstCell.title
        XCTAssertGreaterThan(title?.count ?? 0, 0, "title should not be blank")
    }

    func test_cellForRowAtIndexPath_ImageViewImage_shouldNotBeNil() {
        guard let firstCell = testInstance.tableView(testInstance.tableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? ExploreContentTableViewCell else {
            XCTFail("firstCell must not be nil.")
            return
        }

        let image = firstCell.image
        XCTAssertNotNil(image, "image view image should not be nil")
    }
}
