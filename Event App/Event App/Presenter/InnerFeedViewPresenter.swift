//
//  InnerFeedViewPresenter.swift
//  Event App
//
//  Created by Александр Крайнов on 30.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

class InnerFeedViewPresenter {
    typealias OnActionCompletion = () -> Void

    var events = [Event]()
    var places = [Place?]()
    var view: InnerFeedViewController
    var facade: EventFacade

    init (view: InnerFeedViewController, facade: EventFacade = EventFacadeImpl(service: EventServiceImpl())) {
        self.facade = facade
        self.view = view
    }

    func getEvents(city: City, completion: @escaping OnActionCompletion) {
        facade.getEvents(city: city) { events, places in
            guard let events = events else {
                completion()
                return
            }
            self.events = events
            guard let places = places else {
                completion()
                return
            }
            self.places = places
            self.view.filteredEvents = self.events
            self.view.filteredPlaces = self.places
            completion()
        }
    }
    func loadMore(completion: @escaping OnActionCompletion) {
        facade.getMoreEvents { events, places in
            guard let events = events else {
                completion()
                return
            }
            self.events.append(contentsOf: events)
            guard let places = places else {
                completion()
                return
            }
            self.places.append(contentsOf: places)
            self.view.filteredEvents = self.events
            self.view.filteredPlaces = self.places
            self.view.reloadTableView()
            completion()
        }
    }
}
