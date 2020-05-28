//
//  ProfileViewController.swift
//  Event App
//
//  Created by Александр Крайнов on 28.05.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    let defaults = UserDefaults.standard

    @IBOutlet private var cityPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        cityPicker.dataSource = self
        cityPicker.delegate = self
    }
}

extension ProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        City.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        City.allCases[row].toCity()
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        defaults.removeObject(forKey: "USER_CITY")
        defaults.set(row, forKey: "USER_CITY")
        //swiftlint:disable:next force_cast
        let delegate = UIApplication.shared.delegate as! AppDelegate
        for view in delegate.viewsToReload {
            view.viewDidLoad()
        }
    }
}
