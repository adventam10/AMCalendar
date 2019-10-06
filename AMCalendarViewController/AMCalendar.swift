//
//  AMCalendarDataViewController.swift
//  AMCalendar, https://github.com/adventam10/AMCalendar
//
//  Created by am10 on 2019/10/06.
//  Copyright © 2019 am10. All rights reserved.
//

import UIKit

public class AMCalendar: UIViewController {
    @discardableResult
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
    
    public var headerColor: UIColor = .gray
    public var monthTextColor: UIColor = .black
    public var defaultDateTextColor: UIColor = .black
    public var disabledDateTextColor: UIColor = .lightGray
    public var sundayTextColor: UIColor = .red
    public var saturdayTextColor: UIColor = .init(red: 25.0 / 255.0 , green: 105.0 / 255.0, blue: 255.0 / 255.0 , alpha: 1.0)
    public var selectedDateTextColor: UIColor = .white
    /// Circle color
    public var selectedDateColor: UIColor = .red
    /// Circle border color
    public var nowDateColor: UIColor = .green
    
    /// Locale used in header
    ///
    /// default is Locale(identifier: Locale.preferredLanguages.first!)
    public var locale: Locale?
}

public protocol AMCalendarDelegate: AnyObject {
    func calendar(_ calendar: AMCalendar, didSelectDate date: Date?)
}
