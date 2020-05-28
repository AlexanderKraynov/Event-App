//
//  File.swift
//  Event App
//
//  Created by Александр Крайнов on 25.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import DeepDiff
import Foundation

struct Event: Decodable, DiffAware, Equatable {
    typealias DiffId = Int

    var diffId: DiffId { id }
    let id: Int
    let title: String
    let slug: String
    let dates: [KudagoDate]
    let place: Place?
// MARK: - Event details
    var location: Location?
    var publicationDate: Date?
    var description: String?
    var categories: [String] = []
    var price: String?
    var images: [Image] = []
    var tags: [String] = []

    static func compareContent(_ lhs: Event, _ rhs: Event) -> Bool {
        lhs == rhs
    }
}
