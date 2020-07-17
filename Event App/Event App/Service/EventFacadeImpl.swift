//
//  EventFacadeImpl.swift
//  Event App
//
//  Created by Александр Крайнов on 30.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation
import RealmSwift

class EventFacadeImpl: EventFacade {
    let service: EventService
    let repository: EventRepository
    private var eventToken: NotificationToken?

    init(service: EventService, repository: EventRepository) {
        self.service = service
        self.repository = repository
    }

    func getEvents(city: City, completion: @escaping OnUpdateCompletion) {
        service.getEvents(city: city) { events in
            guard let events = events else {
                completion(nil)
                return
            }
            self.repository.save(events)
        }
        let events = repository.getEvents()
        eventToken = events.observe { _ in
            completion(events.map { $0.event })
        }
    }
    func getEventsInArea(city: City, locationArea: LocationArea, completion: @escaping OnUpdateCompletion) {
        service.getEventsInArea(city: city, locationArea: locationArea) { events in
            guard let events = events else {
                completion(nil)
                return
            }
            var placeIds = [Int?]()
            for event in events {
                placeIds.append(event.place?.id)
            }
            completion(events)
        }
    }

    func getMoreEvents(completion: @escaping OnUpdateCompletion) {
        service.getMoreEvents { events in
            guard let events = events else {
                completion(nil)
                return
            }
            completion(events)
        }
    }

    func getEventsWithCategory(city: City, category: EventCategory, completion: @escaping OnUpdateCompletion) {
        service.getEventsWithTag(city: city, tag: category) { events in
            guard let events = events else {
                completion(nil)
                return
            }
            var placeIds = [Int?]()
            for event in events {
                placeIds.append(event.place?.id)
            }
            completion(events)
        }
    }

    func addEvent(event: Event, for place: Place) {
        service.addEvent(event: event, for: place)
    }
}
