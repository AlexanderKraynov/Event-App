//
//  EventCategory.swift
//  Event App
//
//  Created by Александр Крайнов on 28.05.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

enum EventCategory: String {
    case cinema
    case all
    case exhibition
    case concert

    init(_ string: String) {
        switch string {
        case "Кино":
            self = .cinema
        case "Выставки":
            self = .exhibition
        case "Концерты":
            self = .concert
        default:
            self = .all
        }
    }
    func toCategoryQuery() -> String {
        if self != EventCategory.all {
            return "&categories=\(self.rawValue)"
        } else {
            return ""
        }
    }
}
