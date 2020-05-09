//
//  MapViewPresenter.swift
//  Event App
//
//  Created by Александр Крайнов on 03.05.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

class MapViewPresenter {
    typealias OnActionCompletion = () -> Void

    var view: MapViewController
    var facade: EventFacade
    var events = [Event]()
    var places = [Place?]()

    init (view: MapViewController, facade: EventFacade = EventFacadeImpl(service: EventServiceImpl())) {
        self.facade = facade
        self.view = view
    }

    func getEvents(city: City, completion: @escaping OnActionCompletion) {
        facade.getEventsInArea(city: city, locationArea: view.getLocation()) { events, places in
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
            self.view.filteredEvents = events
            self.view.filteredPlaces = places
            completion()
        }
    }
}
