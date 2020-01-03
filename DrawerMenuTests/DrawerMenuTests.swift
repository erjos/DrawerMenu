//
//  DrawerMenuTests.swift
//  DrawerMenuTests
//
//  Created by Ethan Joseph on 12/27/19.
//  Copyright © 2019 EJDevelopment. All rights reserved.
//

import XCTest
@testable import DrawerMenu

class MockGestureDelegate: DrawerGestureDelegate {
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        //call the gesture on the drawer menu...
    }
}

class DrawerMenuTests: XCTestCase {

    var drawerMenu: DrawerMenu!
    var containingView: UIView!
    var swipePanGesture: UIPanGestureRecognizer!
    
    override func setUp() {
        drawerMenu = DrawerMenu(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        containingView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        containingView.addSubview(drawerMenu)
        drawerMenu.gestureDelegate = MockGestureDelegate()
    }
    
    func testDrawerSetup() {
        drawerMenu.openMenu()
        
        XCTAssertNotNil(drawerMenu.menuView)
        XCTAssertTrue(drawerMenu.isDisplayAdded, "The menu display should be added after openMenu is called once")
    }
    
    func testDrawerClose() {
        drawerMenu.closeMenu()
        
        XCTAssert(drawerMenu.menuView.frame.width == 0)
    }
    
    func testPanGestureSetup() {
        swipePanGesture = drawerMenu.getPanGesture()
    }
    
    func testPanGesture() {
        
        drawerMenu.handleGesture(swipePanGesture)
    }

    override func tearDown() { }
    
}
