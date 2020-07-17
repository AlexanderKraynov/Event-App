//
//  EventRealm.swift
//  Event App
//
//  Created by Александр Крайнов on 13.07.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation
import RealmSwift

class EventRealm: Object {
    // MARK: - Image
    @objc dynamic var id: Int = 0
    @objc dynamic var  title: String = ""
    @objc dynamic var  slug: String = ""
    // MARK: - Date
    @objc dynamic var  start = Date()
    @objc dynamic var  end = Date()
    // MARK: - Place
    @objc dynamic var placeId: Int = 0
    @objc dynamic var placeTitle: String = ""
    @objc dynamic var placeSlug: String = ""
    @objc dynamic var address: String = ""
    @objc dynamic var phone: String = ""
    @objc dynamic var siteUrl: String = ""
    @objc dynamic var subway: String = ""
    @objc dynamic var isClosed: Bool = true
    @objc dynamic var location: String = ""
    @objc dynamic var lat: Double = 0
    @objc dynamic var lon: Double = 0
    // MARK: - Location
    @objc dynamic var  locationSlug: String = ""
    @objc dynamic var  publicationDate: Date?
    @objc dynamic var  eventDescription = ""
    var  categories = List<String>()
    @objc dynamic var  price: String?
    var  images = List<RealmImage>()
    var  tags = List<String>()

    override class func primaryKey() -> String? {
        "id"
    }
}

extension EventRealm {
    var event: Event {
        let locationArea = LocationArea(lat: lat, lon: lon)
        let place = Place(
            id: placeId,
            title: placeTitle,
            slug: placeSlug,
            address: address,
            phone: phone,
            siteUrl: siteUrl,
            subway: subway,
            isClosed: isClosed,
            location: location,
            coords: locationArea
        )
        let loc = Location(slug: locationSlug)
        let img = images.map { $0.toImage() }
        let date = KudagoDate(start: start, end: end)
        return Event(
            id: id,
            title: title,
            slug: slug,
            dates: [date],
            place: place,
            location: loc,
            publicationDate: publicationDate,
            description: description,
            categories: Array(categories),
            price: price,
            images: Array(img),
            tags: Array(tags)
        )
    }

    convenience init(event: Event) {
        self.init()
        id = event.id
        title = event.title
        slug = event.slug
        start = event.dates[0].start
        end = event.dates[0].end
        guard let place = event.place else {
            return
        }
        placeId = place.id
        placeTitle = place.title
        placeSlug = place.slug
        address = place.address
        phone = place.phone
        siteUrl = place.siteUrl
        subway = place.subway
        isClosed = place.isClosed
        location = place.location
        lat = place.coords.lat
        lon = place.coords.lon
        locationSlug = event.location?.slug ?? ""
        publicationDate = event.publicationDate
        eventDescription = event.description ?? ""
        categories.append(objectsIn: event.categories)
        price = event.price
        images.append(objectsIn: event.images.map {
            let image = RealmImage()
            image.image = $0.image
            image.sourceLink = $0.source.link
            image.sourceName = $0.source.name
            return image
        }
        )
        tags.append(objectsIn: event.tags)
    }
}
