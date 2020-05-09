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
                return
            }
            self.events = events
            guard let places = places else {
                return
            }
            self.places = places
            self.view.filteredEvents = events
            self.view.filteredPlaces = places
            completion()
        }
    }
    func loadMore(completion: @escaping OnActionCompletion) {
    }
}
