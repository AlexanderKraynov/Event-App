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
    private var typeButtonsNames = EventCategory.getCollection()
    var filteredEvents = [Event]()
    var userCity = City.msk
    //swiftlint:disable implicitly_unwrapped_optional
    var presenter: InnerFeedViewPresenter!
    var searchBar: UISearchBar!
    //swiftlint:enable imolicitly_unwrapped_optional
    @IBOutlet private var typeButtons: UICollectionView!
    @IBOutlet private var eventTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //swiftlint:disable force_cast
        let delegate = UIApplication.shared.delegate as! AppDelegate
        userCity = City.allCases[UserDefaults.standard.object(forKey: "USER_CITY") as? Int ?? 0]
        if !delegate.viewsToReload.contains(self) {
            delegate.viewsToReload.append(self)
        }
        //swiftlint:enable force_cast
        presenter = InnerFeedViewPresenter(view: self)
        eventTableView.dataSource = self
        eventTableView.delegate = self
        eventTableView.register(cellType: EventView.self)
        typeButtons.register(cellType: InnerFeedViewTypeButtonsCellController.self)
        typeButtons.showsHorizontalScrollIndicator = false
        typeButtons.dataSource = self
        typeButtons.delegate = self
        presenter.getEvents(city: userCity) {
            self.reloadTableView()
        }
    }

    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        IndicatorInfo(title: "Лента")
    }

    func reloadTableView() {
        DispatchQueue.main.async {
            self.eventTableView.reloadData()
        }
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
        self.typeButtonsNames.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: InnerFeedViewTypeButtonsCellController
        cell = typeButtons.dequeueReusableCell(for: indexPath, cellType: InnerFeedViewTypeButtonsCellController.self)
        cell.setup(text: typeButtonsNames[indexPath.row]) {
            let old = self.filteredEvents
            self.presenter.getEventsWithCategory(city: self.userCity, category: EventCategory(self.typeButtonsNames[indexPath.row])) {
                let changes = self.presenter.getDiff(old: old, new: self.filteredEvents)
                DispatchQueue.main.async {
                    self.eventTableView.beginUpdates()
                    if !changes.1.isEmpty {
                        self.eventTableView.deleteRows(at: changes.1, with: .fade)
                    }
                    if !changes.0.isEmpty {
                        self.eventTableView.insertRows(at: changes.0, with: .fade)
                    }
                    self.eventTableView.endUpdates()
                }
            }
        }
        return cell
    }
}

extension InnerFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredEvents.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: EventView.self)
        cell.setup(with: filteredEvents[indexPath.row])
        return cell
    }
    func tableView( _ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = DetailsViewController.instantiate() as DetailsViewController
        viewController.event = filteredEvents[indexPath.row]
        navigationController?.pushViewController(viewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard indexPath.row >= filteredEvents.count - 1  else {
            return
        }

        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))

        self.eventTableView.tableFooterView = spinner
        spinner.hidesWhenStopped = true
        presenter.loadMore {
            DispatchQueue.main.async {
                spinner.stopAnimating()
                if !(self.searchBar.text?.isEmpty ?? false) {
                    self.filteredEvents = self.presenter.filter(with: self.searchBar.text ?? "")
                }
            }
        }
    }
    func searchBarTextChanged(searchText: String) {
        let old = filteredEvents
        filteredEvents = presenter.filter(with: searchText)
        let changes = presenter.getDiff(old: old, new: filteredEvents)
        if !changes.0.isEmpty {
            eventTableView.insertRows(at: changes.0, with: .fade)
        }
        if !changes.1.isEmpty {
            eventTableView.deleteRows(at: changes.1, with: .fade)
        }
    }
}
