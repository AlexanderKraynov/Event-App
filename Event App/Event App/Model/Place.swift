//
//  Place.swift
//  Event App
//
//  Created by Александр Крайнов on 26.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

struct Place: Decodable {
    let id: Int
    let title: String
    let slug: String
    let address: String
    let phone: String
    let siteUrl: String
    let subway: String
    let isClosed: Bool
    let location: String
    let coords: LocationArea
}
