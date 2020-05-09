//
//  EventAnnotation.swift
//  Event App
//
//  Created by Александр Крайнов on 04.05.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation
import MapKit

class EventAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var event: Event?
    var place: Place?
    var title: String?

    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
