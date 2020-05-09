//
//  Image.swift
//  Event App
//
//  Created by Александр Крайнов on 25.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

struct Image: Decodable {
    struct Source: Decodable {
        let name: String
        let link: String
    }

    let image: String
    let source: Source
}
