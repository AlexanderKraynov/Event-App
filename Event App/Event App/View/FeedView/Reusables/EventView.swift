//
//  EventViewController.swift
//  Event App
//
//  Created by Admin on 03.04.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Reusable
import UIKit

class EventView: UITableViewCell, NibReusable {
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.locationLabel.text = ""
    }

    func setup(event: Event, place: Place?) {
        titleLabel.text = event.title
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM hh:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateLabel.text = dateFormatter.string(from: event.dates[0].start)
        self.locationLabel.text = place?.address ?? ""
    }
}
