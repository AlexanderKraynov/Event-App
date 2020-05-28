//
//  KudagoDate.swift
//  Event App
//
//  Created by Александр Крайнов on 25.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

class KudagoDate: Decodable, Equatable {
    let start: Date
    let end: Date

    static func == (lhs: KudagoDate, rhs: KudagoDate) -> Bool {
        lhs.end == rhs.end && lhs.start == rhs.start
    }
}
