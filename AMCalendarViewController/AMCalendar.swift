//
//  AMCalendarDataViewController.swift
//  AMCalendar, https://github.com/adventam10/AMCalendar
//
//  Created by am10 on 2019/10/06.
//  Copyright © 2019 am10. All rights reserved.
//

import UIKit

public class AMCalendar: UIViewController {
    public static func setCalendar(onView: UIView,
                            parentViewController: UIViewController,
                            selectedDate: Date?,
                            delegate: AMCalendarDelegate?) -> AMCalendar {
        let viewController = AMCalendarRootViewController()
        viewController.view.frame = onView.bounds
        viewController.delegate = delegate
        onView.addSubview(viewController.view)
        viewController.setPageViewControlle(date: selectedDate)
        parentViewController.addChild(viewController)
        viewController.didMove(toParent: parentViewController)
        return viewController
    }
}

public protocol AMCalendarDelegate: AnyObject {
    func calendar(_ calendar: AMCalendar, didSelectDate date: Date?)
}
