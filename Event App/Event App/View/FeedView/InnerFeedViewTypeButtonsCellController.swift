//
//  InnerFeedViewTypeButtonsCellController.swift
//  Event App
//
//  Created by Admin on 31.03.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//
import Reusable
import UIKit

final class InnerFeedViewTypeButtonsCellController: UICollectionViewCell, NibReusable {
    @IBOutlet private var button: UIButton!

    func setup(text: String) {
        button.layer.cornerRadius = button.frame.height / 2
        button.backgroundColor = UIColor.purple
        button.clipsToBounds = true
        button.tintColor = UIColor.white
        button.setTitle(text, for: .normal)
    }
}
