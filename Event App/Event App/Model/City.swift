//
//  City.swift
//  Event App
//
//  Created by Александр Крайнов on 25.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

enum City: String, CaseIterable {
    case spb, msk, nsk, ekb, nnv, kzn, vbg, smr, krd, sochi, ufa, krasnoyarsk, kev
    case nyc = "new-york"

    func toCityQuery() -> String {
        "&location=\(self.rawValue)"
    }

    func toCity() -> String {
        switch self {
        case .spb:
            return "Санкт-Петербург"
        case .msk:
            return "Москва"
        case .nsk:
            return "Новосибирск"
        case .ekb:
            return "Екатеринбург"
        case .nnv:
            return "Нижний Новгород"
        case .kzn:
            return "Казань"
        case .vbg:
            return "Выборг"
        case .smr:
            return "Самара"
        case .krd:
            return "Краснодар"
        case .sochi:
            return "Сочи"
        case .ufa:
            return "Уфа"
        case .krasnoyarsk:
            return "Красноярск"
        case .kev:
            return "Киев"
        case .nyc:
            return "Нью-Йорк"
        }
    }
}
