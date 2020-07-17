//
//  EventCategory.swift
//  Event App
//
//  Created by Александр Крайнов on 28.05.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

enum EventCategory: String, CaseIterable {
    case cinema
    case all
    case exhibition
    case concert
    case education
    case entertainment
    case fashion
    case holiday
    case kids
    case other
    case quest
    case photo
    case shopping
    case theater

    init(_ string: String) {
        switch string {
        case "Кино":
            self = .cinema
        case "Выставки":
            self = .exhibition
        case "Концерты":
            self = .concert
        case "Обучение":
            self = .education
        case "Развлечение":
            self = .entertainment
        case "Мода":
            self = .fashion
        case "Праздники":
            self = .holiday
        case "Детям":
            self = .kids
        case "Квесты":
            self = .quest
        case "Фотография":
            self = .photo
        case "Шоппинг":
            self = .shopping
        case "Театр":
            self = .theater
        default:
            self = .all
        }
    }

    static func getCollection() -> [String] {
        [
            "Все",
            "Кино",
            "Выставки",
            "Концерты",
            "Обучение",
            "Развлечение",
            "Мода",
            "Праздники",
            "Детям",
            "Квесты",
            "Фотография",
            "Шоппинг",
            "Театр"
        ]
    }

    func toCategoryQuery() -> String {
        if self != EventCategory.all {
            return "&categories=\(self.rawValue)"
        } else {
            return ""
        }
    }
}
