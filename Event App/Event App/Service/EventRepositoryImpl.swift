//
//  EventRepositoryImpl.swift
//  Event App
//
//  Created by Александр Крайнов on 13.07.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation
import RealmSwift

class EventRepositoryImpl: EventRepository {
    private var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Can't create realm")
        }
    }

    func save(_ events: [Event]) {
        let events = events.map(EventRealm.init(event: ))
        try? realm.write {
            realm.add(events, update: .modified)
        }
    }

    func getEvents() -> Results<EventRealm> {
        realm.objects(EventRealm.self)
    }
}
