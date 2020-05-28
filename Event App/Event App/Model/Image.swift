//
//  Image.swift
//  Event App
//
//  Created by Александр Крайнов on 25.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

struct Image: Decodable, Equatable {
    struct Source: Decodable, Equatable {
        let name: String
        let link: String
    }

    let image: String
    let source: Source
}
