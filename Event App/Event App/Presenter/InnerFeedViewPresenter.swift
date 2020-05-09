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
    var view: InnerFeedViewController
    var facade: EventFacade

    init (view: InnerFeedViewController, facade: EventFacade = EventFacadeImpl(service: EventServiceImpl())) {
        self.facade = facade
        self.view = view
    }

    func getEvents(city: City, completion: @escaping OnActionCompletion) {
        facade.getEvents(city: city) { events in
            guard let events = events else {
                completion()
                return
            }
            self.events = events
            self.view.filteredEvents = self.events
            completion()
        }
    }
    func loadMore(completion: @escaping OnActionCompletion) {
        facade.getMoreEvents { events in
            guard let events = events else {
                completion()
                return
            }
            self.events.append(contentsOf: events)
            self.view.filteredEvents = self.events
            self.view.reloadTableView()
            completion()
        }
    }
}
