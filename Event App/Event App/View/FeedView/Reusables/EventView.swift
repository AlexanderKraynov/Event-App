//
//  EventViewController.swift
//  Event App
//
//  Created by Admin on 03.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//
import Kingfisher
import Reusable
import THLabel
import UIKit

class EventView: UITableViewCell, NibReusable {
    @IBOutlet private var titleLabel: THLabel!
    @IBOutlet private var dateLabel: THLabel!
    @IBOutlet private var locationLabel: THLabel!
    @IBOutlet private var eventImage: UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.locationLabel.text = ""
        eventImage.image = nil
    }

    func setup(with event: Event) {
        guard let imageURL = URL(string: event.images.first?.image ?? "") else {
            return
        }
        eventImage.kf.setImage(with: imageURL)
        titleLabel.text = event.title
        titleLabel.strokeColor = .black
        titleLabel.strokeSize = 1
        dateLabel.strokeColor = .black
        dateLabel.strokeSize = 1
        locationLabel.strokeColor = .black
        locationLabel.strokeSize = 1
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM hh:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateLabel.text = dateFormatter.string(from: event.dates[0].start)
        self.locationLabel.text = event.place?.address ?? ""
    }
}
