//
//  InnerFeedViewController.swift
//  Event App
//
//  Created by Admin on 29.03.2020.
//  Copyright © 2020 eventapp. All rights reserved.
//

import Reusable
import UIKit
import XLPagerTabStrip

class InnerFeedViewController: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
      IndicatorInfo(title: "Лента")
    }
}
extension InnerFeedViewController: StoryboardBased {
}
