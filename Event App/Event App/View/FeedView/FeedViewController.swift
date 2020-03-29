//
//  FirstViewController.swift
//  Event App
//
//  Created by Admin on 26.03.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class FeedViewController: ButtonBarPagerTabStripViewController {
    private let placeholderWidth = 50
    private var offset = UIOffset()

    @IBOutlet private var searchBar: UISearchBar!

    override func viewDidLoad() {
        setUpButtonBar()
        super.viewDidLoad()
        setUpSearchBar()
    }

    func setUpButtonBar() {
        settings.style.buttonBarItemBackgroundColor = UIColor.white.withAlphaComponent(0)
        settings.style.buttonBarItemTitleColor = UIColor.black
        settings.style.buttonBarItemLeftRightMargin = 8
    }

    func setUpSearchBar() {
        dismissKeyboardSetup()
        searchBar.setImage(#imageLiteral(resourceName: "Component 18"), for: .bookmark, state: UIControl.State.normal)
        searchBar.delegate = self
        UISearchBar.appearance().setImage(#imageLiteral(resourceName: "Component 3"), for: UISearchBar.Icon.search, state: UIControl.State.normal)
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.layer.cornerRadius = 20
        textFieldInsideUISearchBar?.clipsToBounds = true
        let offsetPoints = (searchBar.frame.width) / 2
        offset = UIOffset(horizontal: offsetPoints - CGFloat(placeholderWidth), vertical: 0)
        searchBar.setPositionAdjustment(offset, for: .search)
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        [InnerFeedViewController.instantiate(), MapViewController.instantiate()]
    }
}

extension FeedViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
           let noOffset = UIOffset(horizontal: 0, vertical: 0)
           searchBar.setPositionAdjustment(noOffset, for: .search)

           return true
       }

       func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
           searchBar.setPositionAdjustment(offset, for: .search)

           return true
       }
}

extension FeedViewController {
    func dismissKeyboardSetup() {
        let tap = UITapGestureRecognizer( target: self, action: #selector(FeedViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
