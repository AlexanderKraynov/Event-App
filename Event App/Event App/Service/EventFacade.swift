//
//  EventFacade.swift
//  Event App
//
//  Created by Александр Крайнов on 30.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

protocol EventFacade {
    typealias OnUpdateCompletion = ([Event]?) -> Void
    func getEvents(city: City, completion: @escaping OnUpdateCompletion)
    func getEventsInArea(city: City, locationArea: LocationArea, completion: @escaping OnUpdateCompletion)
    func getMoreEvents(completion: @escaping OnUpdateCompletion)
    func getEventsWithCategory(city: City, category: EventCategory, completion: @escaping OnUpdateCompletion)
    func addEvent(event: Event, for place: Place)
}
