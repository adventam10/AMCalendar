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
    
    var calendar1: AMCalendar?
    var calendar2: AMCalendar?
    
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        calendar1 = AMCalendar.setCalendar(onView: calendarBaseView1,
                                           parentViewController: self,
                                           selectedDate: Date(timeIntervalSinceNow: -24*60*60*120),
                                           delegate: self)
        
        calendar2 =
        AMCalendar.setCalendar(onView: calendarBaseView2,
                                                 parentViewController: self,
                                                 selectedDate: nil,
                                                 delegate: self)
        calendar2?.headerColor = .purple
        calendar2?.monthTextColor = .yellow
        calendar2?.defaultDateTextColor = .orange
        calendar2?.disabledDateTextColor = .brown
        calendar2?.sundayTextColor = .green
        calendar2?.saturdayTextColor = .cyan
        calendar2?.selectedDateTextColor = .blue
        calendar2?.selectedDateColor = .magenta
        calendar2?.nowDateColor = .black
        calendar2?.locale = Locale(identifier: "ja_JP")
        
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "yyyy/MM/dd"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: AMCalendarDelegate {
    func calendar(_ calendar: AMCalendar,
                  didSelectDate date: Date?) {
        if calendar1 == calendar {
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

