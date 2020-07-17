//
//  EventRepository.swift
//  Event App
//
//  Created by Александр Крайнов on 13.07.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation
import RealmSwift

protocol EventRepository {
    func save(_ events: [Event])
    func getEvents() -> Results<EventRealm>
}
