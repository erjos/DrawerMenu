//
//  MenuInteractorTests.swift
//  DrawerMenuTests
//
//  Created by Ethan Joseph on 1/4/20.
//  Copyright © 2020 EJDevelopment. All rights reserved.
//

import XCTest
@testable import DrawerMenu

class MockInteractorDelegate: MenuInteractorDelegate {
    var didSelect = false
    var backSelected = false
    var deleted = false
    
    func setDataSource(drawerMenu: DrawerMenu) -> MenuData {
        return MenuData("Menu", ["item1","item2","item3"], false, false)
    }
    
    func didSelectItem(indexPath: IndexPath, label: String) {
        didSelect = true
    }
    
    func didPressBack() {
        backSelected = true
    }
    
    func didDeleteItem(indexPath: IndexPath, label: String) {
        deleted = true
    }
}

class MenuInteractorTests: XCTestCase {
    
    lazy var interactor = MenuInteractor()
    lazy var drawerMenu = DrawerMenu()
    lazy var mockDelegate = MockInteractorDelegate()

    override func setUp() {
        interactor.setup()
        interactor.delegate = mockDelegate
        //Menu must have a visible frame for cells to be added
        interactor.menuTable.setSize(300, 500)
        interactor.loadMenuData(drawerMenu)
    }
    
    func testInteractorSetup() {
        XCTAssertNotNil(interactor.menuTable.delegate)
        XCTAssertNotNil(interactor.menuTable.dataSource)
    }
    
    func testGetData() {
        XCTAssertNotNil(interactor.menuData)
    }
    
    func testLoadMenuData() {
        XCTAssertTrue(interactor.menuTable.numberOfRows(inSection: 0) == 3)
        let cell = interactor.menuTable.cellForRow(at: IndexPath(row: 0, section: 0))
        XCTAssertNotNil(cell)
        XCTAssertTrue(cell?.textLabel?.text == "item1")
    }
    
    func testItemSelection() {
        interactor.tableView(interactor.menuTable, didSelectRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockDelegate.didSelect == true)
    }
    
    func testDidPressEdit() {
        interactor.didPressEdit(shouldEdit: true)
        XCTAssertTrue(interactor.menuTable.isEditing)
    }
    
    func testDidPressBack() {
        interactor.didPressBack()
        XCTAssertTrue(mockDelegate.backSelected)
    }
    
    func testDidDeleteItem() {
        interactor.menuTable.dataSource?.tableView?(interactor.menuTable, commit: .delete, forRowAt: IndexPath(row: 0, section: 0))
        XCTAssertTrue(mockDelegate.deleted)
    }
}
