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

    init (view: MapViewController, facade: EventFacade = EventFacadeImpl(service: EventServiceImpl())) {
        self.facade = facade
        self.view = view
    }

    func getEvents(city: City, completion: @escaping OnActionCompletion) {
        facade.getEventsInArea(city: city, locationArea: view.getLocation()) { events in
            guard let events = events else {
                completion()
                return
            }
            self.events = events
            self.view.filteredEvents = events
            completion()
        }
    }
}
