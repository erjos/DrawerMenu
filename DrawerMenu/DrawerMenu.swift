//
//  DrawerMenu.swift
//  HiitGenerator
//
//  Created by Ethan Joseph on 12/27/19.
//  Copyright © 2019 Ethan Joseph. All rights reserved.
//

import Foundation
import UIKit

public class DrawerMenu: UIControl {
    
    public weak var delegate: MenuInteractorDelegate? {
        get { return menuInteractor.delegate }
        set { menuInteractor.delegate = newValue }
    }
    
    private var menuInteractor : MenuInteractorProtocol = MenuInteractor()
    
    public var menuView : UITableView {
        get { return menuInteractor.menuTable }
    }
    
    private lazy var coverView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    private lazy var shadowView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    private let shadowWidth:CGFloat = 5
    
    
    public private(set) var isDisplayAdded = false
    
    private let DEFAULT_MENU_IMAGE = "menu_black"
    private let BUNDLE_ID = "com.erj.DrawerMenu"
    
    private func setupDisplay() {
        guard !isDisplayAdded else { return }
        guard let parent = self.superview else { return }
        shadowView.setHeight(parent.frame.height)
        coverView.setHeight(parent.frame.height)
        menuView.setHeight(parent.frame.height)
        
        self.superview?.addSubview(shadowView)
        self.superview?.addSubview(menuView)
        self.superview?.addSubview(coverView)
        isDisplayAdded = true
        
        //COVER VIEW
        coverView.backgroundColor = .clear
        coverView.alpha = 0.5
        coverView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCoverTap(_:))))
        
        //MENU VIEW STYLING
        menuView.backgroundColor = .darkGray
        menuView.separatorStyle = .singleLine
        menuView.separatorColor = .black
        menuView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //SHADOW VIEW
        shadowView.backgroundColor = .black
        shadowView.dropShadow()
    }
    
    /**
     Call this function if you want to reload the menu data or change the menu data source. It will trigger the setDataSource(drawerMenu: DrawerMenu)-> MenuData delegate function.
    */
    public func loadMenu() {
        //triggers delegate function on menu interactor to retrieve the data source from the delegate
        menuInteractor.loadMenuData(self)
        
    }
    
    /**
     Opens the menu display.
    */
    public func openMenu() {
        setupDisplay()
        UIView.animate(withDuration: 0.2) {
            guard let parent = self.superview else { return }
            let menuWidth = parent.frame.width * (2/3)
            self.menuView.frame = CGRect(x: 0, y: 0, width: menuWidth, height: parent.frame.height)
            self.shadowView.frame = CGRect(x: (menuWidth - self.shadowWidth), y: 0, width: self.shadowWidth, height: parent.frame.height)
            self.coverView.frame = CGRect(x: menuWidth, y: 0, width: parent.frame.width - menuWidth, height: parent.frame.height)
            self.superview?.layoutIfNeeded()
        }
    }
    
    /**
     Closes the menu display.
    */
    public func closeMenu() {
        UIView.animate(withDuration: 0.2) {
            guard let parent = self.superview else { return }
            self.menuView.frame = CGRect(x: 0, y: 0, width: 0, height: parent.frame.height)
            self.shadowView.frame = CGRect(x: 0, y: 0, width: 0, height: parent.frame.height)
            self.coverView.frame = CGRect(x: 0, y: 0, width: 0, height: parent.frame.height)
            self.superview?.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //Ensures that the pan gesture exists only on the superview of the menu control
    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.handleGesture(_:)))
        superview?.addGestureRecognizer(gesture)
    }

    private func commonInit() {
        self.menuInteractor.setup()
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(DrawerMenu.didTap(_:))))
        
        let menuImage = UIImage(named: DEFAULT_MENU_IMAGE, in: Bundle(identifier: "com.erj.DrawerMenu"), with: nil)
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        imageView.image = menuImage
        self.addSubview(imageView)
        
        self.loadMenu()
    }
    
    @objc func handleCoverTap(_ gesture: UITapGestureRecognizer) {
        closeMenu()
    }
    
    @objc func didTap(_ gesture: UITapGestureRecognizer) {
        openMenu()
    }
    
    func panGestureChanged(_ newWidth: CGFloat, _ parent: UIView) {
        self.menuView.frame = CGRect(x: 0, y: 0, width: newWidth, height: parent.frame.height)
        self.coverView.frame = CGRect(x: newWidth, y: 0, width: parent.frame.width - newWidth, height: parent.frame.height)
        self.shadowView.frame = CGRect(x: newWidth - shadowWidth, y: 0, width: shadowWidth, height: parent.frame.height)
    }
    
    //TODO: the 150 marker needs to change to reflect the potential dynamic width of the screen the menu is on
    func panGestureEnded(_ leftToRight: Bool, _ menuView: UITableView) {
        if leftToRight {
            let hasMovedGreaterThanHalfway = (menuView.frame.width) > 150
            if (hasMovedGreaterThanHalfway) {
                self.openMenu()
            } else {
                self.closeMenu()
            }
        } else {
            let hasMovedGreaterThanHalfway = (menuView.frame.width) < 150
            if (hasMovedGreaterThanHalfway) {
                self.closeMenu()
            } else {
                self.openMenu()
            }
        }
    }
    
    /**
      * This function handles the gesture logic for the standard sliding drawer behavior.
     - Parameters:
        - gesture: The pan gesture on the view, which controls the menu.
    */
    @objc func handleGesture(_ gesture: UIPanGestureRecognizer) {
        setupDisplay()
        guard let parent = self.superview else { return }
        let gestureIsDraggingFromLeftToRight = (gesture.velocity(in: superview).x > 0)
        switch gesture.state {
        case .began:
            return
        case .changed:
            if let _ = gesture.view {
                let newWidth = (self.menuView.frame.width) + gesture.translation(in: parent).x
                panGestureChanged(newWidth, parent)
                gesture.setTranslation(CGPoint.zero, in: parent)
            }
        case .ended:
            panGestureEnded(gestureIsDraggingFromLeftToRight, menuView)
        default:
            break
        }
    }
}
