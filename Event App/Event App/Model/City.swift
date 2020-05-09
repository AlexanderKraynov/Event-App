//
//  City.swift
//  Event App
//
//  Created by Александр Крайнов on 25.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

enum City: String {
    case spb, msk, nsk, ekb, nnv, kzn, vbg, smr, krd, sochi, ufa, krasnoyarsk, kev
    case nyc = "new-york"

    func toCityQuery() -> String {
        "&location=\(self.rawValue)"
    }
}
