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
    var containingView : UIView!
    var menuInteractor : MenuInteractorProtocol = MenuInteractor()
    var header = DrawerHeaderView()
    
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
    
    func testLoadMenuData() {
        //this will trigger most of the table view methods 
        drawerMenu.loadMenu()
        drawerMenu.openMenu()
    }
    
    func testDelegate() {
        let mockDelegate = MockInteractorDelegate()
        drawerMenu.delegate = mockDelegate
        XCTAssertNotNil(drawerMenu.delegate)
    }
    
    func testCoverTap() {
        drawerMenu.openMenu()
        let tap = UITapGestureRecognizer(target: self, action: #selector(drawerMenu.handleCoverTap(_:)))
        drawerMenu.handleCoverTap(tap)
        XCTAssertTrue(drawerMenu.menuView.frame.width == 0)
    }
    
    func testMenuOpenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(drawerMenu.didTap(_:)))
        drawerMenu.didTap(tap)
        XCTAssertTrue(drawerMenu.menuView.frame.width != 0)
    }
    
    func testPanGestureBegan() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(drawerMenu.handleGesture(_:)))
        pan.state = .began
        drawerMenu.handleGesture(pan)
        XCTAssertTrue(drawerMenu.menuView.frame.width == 0)
    }
    
    func testPanGestureEnded() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(drawerMenu.handleGesture(_:)))
        pan.state = .ended
        drawerMenu.handleGesture(pan)
    }
    
    func testPanGestureChanged() {
        let pan = UIPanGestureRecognizer(target: containingView, action: #selector(drawerMenu.handleGesture(_:)))
        containingView.addGestureRecognizer(pan)
        pan.state = .began
        pan.setTranslation(CGPoint(x: 50, y: 50), in: containingView)
        pan.state = .changed
        XCTAssertTrue(pan.state == .changed)
        drawerMenu.handleGesture(pan)
        XCTAssertTrue(pan.translation(in: containingView) == CGPoint.zero)
    }
}
