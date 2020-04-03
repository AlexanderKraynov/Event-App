//
//  InnerFeedViewController.swift
//  Event App
//
//  Created by Admin on 29.03.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Reusable
import UIKit
import XLPagerTabStrip

class InnerFeedViewController: UIViewController, IndicatorInfoProvider, UICollectionViewDataSource {
    private var dateButtonsNames = ["Сегодня", "Завтра"]
    private var typeButtonsNames = ["Все", "Кино", "Выставки", "Концерты", "Name"]
    @IBOutlet private var typeButtons: UICollectionView!
    @IBOutlet private var dateButtons: UICollectionView!
    @IBOutlet private var eventTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.register(cellType: EventView.self)
        typeButtons.register(cellType: InnerFeedViewTypeButtonsCellController.self)
        typeButtons.showsHorizontalScrollIndicator = false
        typeButtons.dataSource = self
        typeButtons.delegate = self
        dateButtons.register(cellType: InnerFeedViewTypeButtonsCellController.self)
        dateButtons.dataSource = self
        dateButtons.delegate = self
        dateButtons.isScrollEnabled = false
    }
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
      IndicatorInfo(title: "Лента")
    }
}
extension InnerFeedViewController: StoryboardBased {
}

extension InnerFeedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView (_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = typeButtonsNames[indexPath.row]
            .width(withConstrainedHeight: 50, font: UIFont(name: "Montserrat", size: 20) ?? UIFont.italicSystemFont(ofSize: 10), minimumTextWrapWidth: 10)
        return CGSize(width: width + 100, height: 50)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView === typeButtons {
            return self.typeButtonsNames.count
        } else {
            return self.dateButtonsNames.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: InnerFeedViewTypeButtonsCellController
        if collectionView === typeButtons {
            cell = typeButtons.dequeueReusableCell(for: indexPath, cellType: InnerFeedViewTypeButtonsCellController.self)
            cell.setup(text: typeButtonsNames[indexPath.row])
        } else {
            cell = dateButtons.dequeueReusableCell(for: indexPath, cellType: InnerFeedViewTypeButtonsCellController.self)
            cell.setup(text: dateButtonsNames[indexPath.row])
        }
        return cell
    }
}

extension InnerFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EventView.self)
         return cell
    }
}
