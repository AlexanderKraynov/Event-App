//
//  EventFacadeImpl.swift
//  Event App
//
//  Created by Александр Крайнов on 30.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

class EventFacadeImpl: EventFacade {
    let service: EventService

    init(service: EventService) {
        self.service = service
    }
    func getEvents(city: City, completion: @escaping OnUpdateCompletion) {
        service.getEvents(city: city) { events in
            guard let events = events else {
                completion(nil, nil)
                return
            }
            var placeIds = [Int?]()
            for event in events {
                placeIds.append(event.place?.id)
            }
            self.service.getPlaces(with: placeIds) { places in
                guard let places = places else {
                    completion(events, nil)
                    return
                }
                completion(events, places)
            }
        }
    }
    func getEventsInArea(city: City, locationArea: LocationArea, completion: @escaping OnUpdateCompletion) {
        service.getEventsInArea(city: city, locationArea: locationArea) { events in
            guard let events = events else {
                completion(nil, nil)
                return
            }
            var placeIds = [Int?]()
            for event in events {
                placeIds.append(event.place?.id)
            }
            self.service.getPlaces(with: placeIds) { places in
                guard let places = places else {
                    completion(events, nil)
                    return
                }
                completion(events, places)
            }
        }
    }

    func getMoreEvents(completion: @escaping OnUpdateCompletion) {
        service.getMoreEvents { events in
            guard let events = events else {
                completion(nil, nil)
                return
            }
            var placeIds = [Int?]()
            for event in events {
                placeIds.append(event.place?.id)
            }
            self.service.getPlaces(with: placeIds) { places in
                guard let places = places else {
                    completion(events, nil)
                    return
                }
                completion(events, places)
            }
        }
    }

    func addEvent(event: Event, for place: Place) {
        service.addEvent(event: event, for: place)
    }
}
