//
//  RealmImage.swift
//  Event App
//
//  Created by Александр Крайнов on 13.07.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation
import RealmSwift

class RealmImage: Object {
    @objc dynamic var image = ""
    @objc dynamic var sourceName = ""
    @objc dynamic var sourceLink = ""

    func toImage() -> Image {
        Image(image: image, source: Image.Source(name: sourceName, link: sourceLink))
    }
}
