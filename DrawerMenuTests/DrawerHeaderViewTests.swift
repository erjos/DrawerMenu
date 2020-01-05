//
//  DrawerHeaderViewTests.swift
//  DrawerMenuTests
//
//  Created by Ethan Joseph on 1/4/20.
//  Copyright © 2020 EJDevelopment. All rights reserved.
//

import XCTest
@testable import DrawerMenu

class MockHeaderDelegate: HeaderViewDelegate {
    var editPressed = false
    var backPressed = false
    
    func didPressBack() {
        backPressed = true
    }
    
    func didPressEdit(shouldEdit: Bool) {
        editPressed = true
    }
    
}

class DrawerHeaderViewTests: XCTestCase {
    lazy var menuData = MenuData("Menu", ["item1","item2","item3"], false, false)
    lazy var mockDelegate = MockHeaderDelegate()
    var headerView : DrawerHeaderView!

    override func setUp() {
        let bundle = Bundle(identifier: "com.erj.DrawerMenu")
        headerView = UINib(nibName: "DrawerHeaderView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as? DrawerHeaderView
        headerView.setupHeaderView(menuData, 0)
        headerView.delegate = mockDelegate
    }

    func testHeaderSetupBackEditHidden() {
        XCTAssertTrue(headerView.headerLabel.text == "Menu")
        XCTAssertTrue(headerView.backButton.isHidden)
        XCTAssertTrue(headerView.editDoneButton.isHidden)
    }

    func testHeaderSetupBackEditShown() {
        menuData.backButtonVisible = true
        menuData.shouldEdit = true
        headerView.setupHeaderView(menuData, 0)
        XCTAssertTrue(!headerView.backButton.isHidden)
        XCTAssertTrue(!headerView.editDoneButton.isHidden)
    }

    func testEditPressed() {
        headerView.editButtonPressed(mockDelegate)
        XCTAssertTrue(headerView.editDoneButton.currentTitle == "Done")
        XCTAssertTrue(mockDelegate.editPressed)
        mockDelegate.editPressed = false
        headerView.editButtonPressed(mockDelegate)
        XCTAssertTrue(headerView.editDoneButton.currentTitle == "Edit")
        XCTAssertTrue(mockDelegate.editPressed)
    }

    func testPressBack() {
        headerView.backButtonPressed(mockDelegate)
        XCTAssertTrue(mockDelegate.backPressed)
    }
}
