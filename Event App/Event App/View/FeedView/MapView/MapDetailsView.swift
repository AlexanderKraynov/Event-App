//
//  MapDetailsView.swift
//  Event App
//
//  Created by Александр Крайнов on 04.05.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Foundation
import UIKit

class MapDetailsView: UIView {
    var event: Event?
    var place: Place?
    @IBOutlet private var eventImage: UIImageView!
    @IBOutlet private var eventName: UILabel!
    @IBOutlet private var placeName: UILabel!
    @IBOutlet private var placeAdress: UILabel!
    @IBOutlet private var price: UILabel!
    @IBOutlet private var dates: UILabel!

    func setup(event: Event, place: Place) {
        self.event = event
        self.place = place
        eventImage.image = nil
        guard let imageURL = URL(string: event.images.first?.image ?? "") else {
            return
        }
        let imageLoadTask = URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.eventImage.image = image
            }
        }
        imageLoadTask.resume()
        eventName.text = event.title
        placeName.text = place.title
        placeAdress.text = place.address
        price.text = event.price
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM hh:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let datesMap = event.dates.map {
            "\(dateFormatter.string(from: $0.start)) - \(dateFormatter.string(from: $0.end))"
        }
        dates.text = datesMap.joined(separator: " ")
    }
}
