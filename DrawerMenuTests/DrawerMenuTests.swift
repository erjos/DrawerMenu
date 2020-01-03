//
//  DrawerMenuTests.swift
//  DrawerMenuTests
//
//  Created by Ethan Joseph on 12/27/19.
//  Copyright © 2019 EJDevelopment. All rights reserved.
//

import XCTest
@testable import DrawerMenu

class DrawerMenuTests: XCTestCase {

    var drawerMenu: DrawerMenu!
    var containingView: UIView!
    
    override func setUp() {
        drawerMenu = DrawerMenu(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        containingView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 600))
        containingView.addSubview(drawerMenu)
    }
    
    func testIsPanGestureAdded() {
        XCTAssert(containingView.gestureRecognizers?.count == 1)
    }
    
    func testDrawerSetup() {
        drawerMenu.openMenu()
        
        XCTAssertNotNil(drawerMenu.menuView)
        XCTAssertTrue(drawerMenu.isDisplayAdded)
        
        //might be nice to create an accessible bool that indicates whether or not the menu is open
        XCTAssertTrue(drawerMenu.menuView.frame.width > 0)
    }
    
    func testDrawerClose() {
        drawerMenu.closeMenu()
        
        XCTAssert(drawerMenu.menuView.frame.width == 0)
    }
    
    func testPanEndedShouldOpen() {
        //this will need to be changed when we update the 150 value
        drawerMenu.menuView.setWidth(160)
        drawerMenu.panGestureEnded(true, drawerMenu.menuView)
        XCTAssertTrue(drawerMenu.menuView.frame.width > 0)
    }
    
    func testPanEndedShouldClose() {
        drawerMenu.menuView.setWidth(140)
        drawerMenu.panGestureEnded(false, drawerMenu.menuView)
        XCTAssertTrue(drawerMenu.menuView.frame.width == 0)
    }

    override func tearDown() { }
    
}
