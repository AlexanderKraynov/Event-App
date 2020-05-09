//
//  DetailsViewController.swift
//  Event App
//
//  Created by Александр Крайнов on 09.05.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Reusable
import UIKit

class DetailsViewController: UIViewController, StoryboardBased {
    var event: Event?
    var place: Place?

    @IBOutlet private var eventImageView: UIImageView!
    @IBOutlet private var eventNameLabel: UILabel!
    @IBOutlet private var eventPlaceLabel: UILabel!
    @IBOutlet private var eventDescriptionLabel: UILabel!
    @IBOutlet private var eventDatesLabel: UILabel!
    @IBOutlet private var eventAdressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let event = event else {
            return
        }
        guard let imageURL = URL(string: event.images.first?.image ?? "") else {
            return
        }
        let imageLoadTask = URLSession.shared.dataTask(with: imageURL) { data, _, _ in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.eventImageView.image = image
            }
        }
        imageLoadTask.resume()
        eventNameLabel.text = event.title
        eventPlaceLabel.text = place?.title ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM hh:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let datesMap = event.dates.map {
            "\(dateFormatter.string(from: $0.start)) - \(dateFormatter.string(from: $0.end))\n"
        }
        eventDatesLabel.text = datesMap.joined(separator: " ")
        eventDescriptionLabel.text = event.description
        eventAdressLabel.text = place?.address ?? "Не указано"
    }
}
