//
//  MenuDataTests.swift
//  DrawerMenuTests
//
//  Created by Ethan Joseph on 1/4/20.
//  Copyright © 2020 EJDevelopment. All rights reserved.
//

import XCTest
@testable import DrawerMenu

class MenuDataTests: XCTestCase {
    func testMenuDataInitializer() {
        let menuSection = MenuSection(["item1","item2","item3"], title: "MockMenu")
        let menuData = MenuData([menuSection])
        XCTAssertNotNil(menuData)
    }
    
    func testMenuDataInitWSections() {
        let menuSection = MenuSection(["item1","item2","item3"], title: "Section1")
        let menuSectionTwo = MenuSection(["item1","item2","item3"], title: "Section2")
        let menuData = MenuData("Menu", ["item1","item2","item3"], false, false)
        XCTAssertNotNil(menuData)
    }
}
