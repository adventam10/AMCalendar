//
//  AMCalendarRootViewController.swift
//  AMCalendar, https://github.com/adventam10/AMCalendar
//
//  Created by am10 on 2017/12/31.
//  Copyright © 2017年 am10. All rights reserved.
//

import UIKit

public protocol AMCalendarRootViewControllerDelegate: class {
    func calendarRootViewController(_ calendarRootViewController: AMCalendarRootViewController, didSelectDate date: Date?)
}

public class AMCalendarRootViewController: UIViewController {
    
    weak public var delegate:AMCalendarRootViewControllerDelegate?
    
    private let pageViewController = UIPageViewController(transitionStyle: .pageCurl,
                                                          navigationOrientation: .vertical,
                                                          options: nil)
    
    private let pageIndexList:[Int] = [0, 1, 2, 3, 4]
    
    private var selectedDate:Date?
    
    private var isPageAnimating = false
    
    private let calendar = Calendar(identifier: .gregorian)
    
    private var firstPageDate:Date?
    
    class public func setCalendar(onView:UIView,
                           parentViewController:UIViewController,
                           selectedDate:Date?,
                           delegate:AMCalendarRootViewControllerDelegate?) -> AMCalendarRootViewController {
        let viewController = AMCalendarRootViewController()
        viewController.view.frame = onView.bounds
        viewController.delegate = delegate
        onView.addSubview(viewController.view)
        viewController.setPageViewControlle(date: selectedDate)
        parentViewController.addChild(viewController)
        viewController.didMove(toParent: parentViewController)
        return viewController
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setPageViewControlle(date:Date?) {
        view.backgroundColor = UIColor.lightGray
        selectedDate = date
        firstPageDate = (date != nil) ? date : Date()
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let startingViewController = createViewController(atIndex: 0, isNext: true)
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
    
    private func createViewController(atIndex index:Int, isNext:Bool) -> AMCalendarDataViewController? {
        if pageIndexList.count == 0 || index >= pageIndexList.count {
            return nil
        }
        
        let bundle = Bundle(for: AMCalendarDataViewController.self)
        let dataViewController = AMCalendarDataViewController(nibName: "AMCalendarDataViewController", bundle: bundle)
        dataViewController.pageIndex = pageIndexList[index]
        dataViewController.delegate = self
        dataViewController.selectedDate = selectedDate
        
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
    
    private func indexOf(viewController:AMCalendarDataViewController) -> Int? {
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
        if isPageAnimating {
            return nil
        }
        
        guard var index = indexOf(viewController: viewController as! AMCalendarDataViewController) else {
            return nil
        }
        
        if index == 0 {
            index = pageIndexList.count - 1
        } else {
            index -= 1
        }
        
        return createViewController(atIndex: index, isNext: false)
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if isPageAnimating {
            return nil
        }
        
        guard var index = indexOf(viewController: viewController as! AMCalendarDataViewController) else {
            return nil
        }
        
        index += 1
        if index == pageIndexList.count {
            index = 0
        }
        
        return createViewController(atIndex: index, isNext: true)
    }
}

extension AMCalendarRootViewController: AMCalendarDataViewControllerDelegate {
    func calendarDataViewController(_ calendarDataViewController:AMCalendarDataViewController,
                                    didSelectDate date:Date?) {
        selectedDate = date
        delegate?.calendarRootViewController(self, didSelectDate: date)
    }
}
