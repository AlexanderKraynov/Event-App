//
//  EventServiceImpl.swift
//  Event App
//
//  Created by Александр Крайнов on 25.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation

class EventServiceImpl: EventService {
    private let basePreviewURL =  "https://kudago.com/public-api/v1.4/events/?text_format=text&fields=id,title,slug,dates,place"
    private let fullDescriptionExtensionURL = ",publication_date,description,categories,price,images,tags"
    private let basePlaceURL = "https://kudago.com/public-api/v1.2/places/"
    private let fullDescriptionPlaceUrl = "?fields=id,title,phone,slug,address,subway,has_parking_lot,location,site_url,is_closed,coords&ids="
    private var nextPage: URL?

    func getEvents(city: City, completion: @escaping EventCompletion) {
        guard let url = URL(string: basePreviewURL + fullDescriptionExtensionURL + (city.toCityQuery())) else {
            completion(nil)
            return
        }
        getEvents(url: url, completion: completion)
    }

    func getMoreEvents(completion: @escaping EventCompletion) {
        guard let url = nextPage else {
            completion(nil)
            return
        }
        getEvents(url: url, completion: completion)
    }

    func getEventsInArea(city: City, locationArea: LocationArea, completion: @escaping EventCompletion) {
        guard let url = URL(
            string: basePreviewURL +
            fullDescriptionExtensionURL +
            (city.toCityQuery()) + "&lat=\(locationArea.lat)&lon=\(locationArea.lon)&radius=10000" + "&page_size=40"
            ) else {
            completion(nil)
            return
        }
        getEvents(url: url, completion: completion)
    }

    private func getEvents(url: URL, completion: @escaping EventCompletion) {
        URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            var page: Page<Event>?
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            //swiftlint:disable:next force_try
            page = try! decoder.decode(Page<Event>.self, from: data)
            self.nextPage = URL(string: page?.next ?? "")
            completion(page?.results)
        }
    .resume()
    }

    func getPlaces(with id: [Int?], completion: @escaping PlaceCompletion) {
        var resultURL = basePlaceURL + fullDescriptionPlaceUrl
        for i in id {
            resultURL += "\(i ?? -1),"
        }
        if resultURL.last == "," {
           _ = resultURL.popLast()
        }
        guard let url = URL(string: resultURL) else {
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) {data, _, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            var page: Page<Place?>?
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            //swiftlint:disable:next force_try
            page = try! decoder.decode(Page<Place?>.self, from: data)
            completion(page?.results)
        }
    .resume()
    }
    func addEvent(event: Event, for place: Place) {
    }
}
