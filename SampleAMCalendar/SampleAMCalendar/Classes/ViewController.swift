//
//  ViewController.swift
//  SampleAMCalendar
//
//  Created by am10 on 2018/01/08.
//  Copyright © 2018年 am10. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var calendarBaseView1: UIView!
    @IBOutlet weak var calendarBaseView2: UIView!
    
    var calendar1: AMCalendarRootViewController?
    var calendar2: AMCalendarRootViewController?
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        calendar1 =
        AMCalendarRootViewController.setCalendar(onView: calendarBaseView1,
                                                 parentViewController: self,
                                                 selectedDate: Date(timeIntervalSinceNow: -24*60*60*120),
                                                 delegate: self)
        
        calendar2 =
        AMCalendarRootViewController.setCalendar(onView: calendarBaseView2,
                                                 parentViewController: self,
                                                 selectedDate: nil,
                                                 delegate: self)
        
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: AMCalendarRootViewControllerDelegate {
    func calendarRootViewController(_ calendarRootViewController: AMCalendarRootViewController,
                                    didSelectDate date: Date?) {
        if calendar1 == calendarRootViewController {
            if let date = date {
                label1.text = dateFormatter.string(from: date)
            }
        } else {
            if let date = date {
                label2.text = dateFormatter.string(from: date)
            }
        }
    }
}

