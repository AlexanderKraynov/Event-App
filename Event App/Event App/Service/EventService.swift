//
//  EventService.swift
//  Event App
//
//  Created by Александр Крайнов on 25.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

protocol EventService {
    typealias EventCompletion = ([Event]?) -> Void
    func getEvents(city: City, completion: @escaping EventCompletion)
    func getEventsInArea(city: City, locationArea: LocationArea, completion: @escaping EventCompletion)
    func getEventsWithTag(city: City, tag: EventCategory, completion: @escaping EventCompletion)
    func getMoreEvents(completion: @escaping EventCompletion)
    func addEvent(event: Event, for place: Place)
}
