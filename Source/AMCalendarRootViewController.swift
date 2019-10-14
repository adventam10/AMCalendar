//
//  AMCalendarRootViewController.swift
//  AMCalendar, https://github.com/adventam10/AMCalendar
//
//  Created by am10 on 2017/12/31.
//  Copyright © 2017年 am10. All rights reserved.
//

import UIKit

class AMCalendarRootViewController: AMCalendar {
    
    weak public var delegate: AMCalendarDelegate?
    
    private let pageViewController = UIPageViewController(transitionStyle: .pageCurl,
                                                          navigationOrientation: .vertical,
                                                          options: nil)
    private let pageIndexList: [Int] = [0, 1, 2, 3, 4]
    private let calendar = Calendar(identifier: .gregorian)
    
    private var selectedDate: Date?
    private var firstPageDate: Date?
    private var isPageAnimating = false
    
    private var dataViewControllers: [AMCalendarDataViewController] {
        return pageViewController.viewControllers as! [AMCalendarDataViewController]
    }
    
    override var headerColor: UIColor {
        didSet {
            dataViewControllers.forEach { $0.headerColor = headerColor }
            view.backgroundColor = headerColor
        }
    }
    
    override var monthTextColor: UIColor {
        didSet {
            dataViewControllers.forEach { $0.monthTextColor = monthTextColor }
        }
    }
    
    override var defaultDateTextColor: UIColor {
        didSet {
            dataViewControllers.forEach { $0.defaultDateTextColor = defaultDateTextColor }
        }
    }
    
    override var disabledDateTextColor: UIColor {
        didSet {
            dataViewControllers.forEach { $0.disabledDateTextColor = disabledDateTextColor }
        }
    }
    
    override var sundayTextColor: UIColor {
        didSet {
            dataViewControllers.forEach { $0.sundayTextColor = sundayTextColor }
        }
    }
    
    override var saturdayTextColor: UIColor {
        didSet {
            dataViewControllers.forEach { $0.saturdayTextColor = saturdayTextColor }
        }
    }
    
    override var selectedDateTextColor: UIColor {
        didSet {
            dataViewControllers.forEach { $0.selectedDateTextColor = selectedDateTextColor }
        }
    }
    
    override var selectedDateColor: UIColor {
        didSet {
            dataViewControllers.forEach { $0.selectedDateColor = selectedDateColor }
        }
    }
    
    override var nowDateColor: UIColor {
        didSet {
            dataViewControllers.forEach { $0.nowDateColor = nowDateColor }
        }
    }
    
    override var locale: Locale? {
        didSet {
            dataViewControllers.forEach { $0.locale = locale }
        }
    }
    
    func setPageViewControlle(date: Date?) {
        view.backgroundColor = headerColor
        selectedDate = date
        firstPageDate = (date != nil) ? date : Date()
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let startingViewController = makeViewController(atIndex: 0, isNext: true)
        pageViewController.setViewControllers([startingViewController!],
                                              direction: .forward,
                                              animated: false,
                                              completion: nil)
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        
        var pageViewRect = view.bounds
        pageViewRect = pageViewRect.insetBy(dx: 1.0, dy: 1.0)
        pageViewController.view.frame = pageViewRect
        pageViewController.didMove(toParent: self)
    }
    
    private func makeViewController(atIndex index: Int, isNext: Bool) -> AMCalendarDataViewController? {
        if pageIndexList.count == 0 || index >= pageIndexList.count {
            return nil
        }
        
        let dataViewController = makeDataViewController(index: index)
        if pageViewController.viewControllers?.count == 0 {
            guard let monthDate = firstPageDate else {
                return nil
            }
            
            var components = calendar.dateComponents([.year, .month, .day, .weekday], from: monthDate)
            components.day = 1
            dataViewController.monthDate = calendar.date(from: components)
            return dataViewController
        }
        
        let currentViewController = pageViewController.viewControllers![0] as! AMCalendarDataViewController
        guard let monthDate = currentViewController.monthDate else {
            return nil
        }
        var components = DateComponents()
        components.month = (isNext) ? 1 : -1
        dataViewController.monthDate = calendar.date(byAdding: components, to: monthDate)
        return dataViewController
    }
    
    private func makeDataViewController(index: Int) -> AMCalendarDataViewController {
        let bundle = Bundle(for: AMCalendarDataViewController.self)
        let viewController = AMCalendarDataViewController(nibName: "AMCalendarDataViewController", bundle: bundle)
        viewController.pageIndex = pageIndexList[index]
        viewController.delegate = self
        viewController.selectedDate = selectedDate
        viewController.headerColor = headerColor
        viewController.monthTextColor = monthTextColor
        viewController.defaultDateTextColor = defaultDateTextColor
        viewController.disabledDateTextColor = disabledDateTextColor
        viewController.sundayTextColor = sundayTextColor
        viewController.saturdayTextColor = saturdayTextColor
        viewController.selectedDateTextColor = selectedDateTextColor
        viewController.selectedDateColor = selectedDateColor
        viewController.nowDateColor = nowDateColor
        viewController.locale = locale
        return viewController
    }
    
    private func index(of viewController: AMCalendarDataViewController) -> Int? {
        return pageIndexList.firstIndex(of: viewController.pageIndex)
    }
}

extension AMCalendarRootViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   willTransitionTo pendingViewControllers: [UIViewController]) {
        isPageAnimating = true
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   didFinishAnimating finished: Bool,
                                   previousViewControllers: [UIViewController],
                                   transitionCompleted completed: Bool) {
        if completed || finished {
            isPageAnimating = false
        }
    }
}

extension AMCalendarRootViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard !isPageAnimating,
           var index = index(of: viewController as! AMCalendarDataViewController) else {
            return nil
        }
        
        index = index == 0 ? pageIndexList.count - 1 : index - 1
        return makeViewController(atIndex: index, isNext: false)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard !isPageAnimating,
           var index = index(of: viewController as! AMCalendarDataViewController) else {
            return nil
        }
       
        index = index == pageIndexList.indices.last ? 0 : index + 1
        return makeViewController(atIndex: index, isNext: true)
    }
}

extension AMCalendarRootViewController: AMCalendarDataViewControllerDelegate {
    func calendarDataViewController(_ calendarDataViewController: AMCalendarDataViewController,
                                    didSelectDate date: Date?) {
        selectedDate = date
        delegate?.calendar(self, didSelectDate: date)
    }
}
