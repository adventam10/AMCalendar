//
//  AMCalendarDataViewController.swift
//  AMCalendar, https://github.com/adventam10/AMCalendar
//
//  Created by am10 on 2017/12/31.
//  Copyright © 2017年 am10. All rights reserved.
//

import UIKit

protocol AMCalendarDataViewControllerDelegate: class {
    func calendarDataViewController(_ calendarDataViewController: AMCalendarDataViewController, didSelectDate date: Date?)
}

class AMCalendarDataViewController: UIViewController {

    weak var delegate:AMCalendarDataViewControllerDelegate?
    
    @IBOutlet private var dayButtons: [UIButton]!
    @IBOutlet weak private var yearMonthLabel: UILabel!
    
    private let headerDateFormatter = DateFormatter()
    
    private let dateFormatter = DateFormatter()
    
    private let selectedDateView = UIView()
    
    private var selectedDateLayer:CAShapeLayer?
    
    private var nowDateLayer:CAShapeLayer?
    
    @IBOutlet private var weekLabels: [UILabel]!
    @IBOutlet private weak var calendarView: UIView!
    var selectedDate:Date?
    
    var monthDate:Date?
    
    var pageIndex:Int = 0
    
    private let selectedDateColor = UIColor.red
    
    private let nowDateColor = UIColor.green
    
    private let nowDateLayerLineWidth:CGFloat = 1.0
    
    private let calendar = Calendar(identifier: .gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dayButtons.sort{$0.tag < $1.tag}
        weekLabels.sort{$0.tag < $1.tag}
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
  
        reloadCalendar()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showSelectView(dayButton:UIButton) {
        calendarView.insertSubview(selectedDateView, at: 0)
        selectedDateLayer = CAShapeLayer()
        guard let selectedDateLayer = selectedDateLayer else {
            return
        }
        
        let buttonFrame = calendarView.convert(dayButton.bounds, from: dayButton)
        selectedDateView.frame = buttonFrame
        var length:CGFloat = (buttonFrame.width > buttonFrame.height) ? buttonFrame.height : buttonFrame.width
        length -= 10
        let path = UIBezierPath(ovalIn: CGRect(x: buttonFrame.width/2 - length/2,
                                               y: buttonFrame.height/2 - length/2,
                                               width: length,
                                               height: length))
        
        selectedDateLayer.frame = selectedDateView.bounds
        selectedDateLayer.fillColor = selectedDateColor.cgColor
        selectedDateLayer.path = path.cgPath

        selectedDateView.layer.addSublayer(selectedDateLayer)
        
        selectedDateView.isHidden = false
    }
    
    private func clearSelectView() {
        selectedDateView.removeFromSuperview()
        selectedDateLayer?.removeFromSuperlayer()
        selectedDateLayer = nil
        selectedDateView.isHidden = true
    }
    
    private func showNowDateLayer(dayButton:UIButton) {
        nowDateLayer = CAShapeLayer()
        guard let nowDateLayer = nowDateLayer else {
            return
        }
        
        let buttonFrame = calendarView.convert(dayButton.bounds, from: dayButton)
        var length:CGFloat = (buttonFrame.width > buttonFrame.height) ? buttonFrame.height : buttonFrame.width
        length -= 10
        let path = UIBezierPath(ovalIn: CGRect(x: buttonFrame.width/2 - length/2,
                                               y: buttonFrame.height/2 - length/2,
                                               width: length,
                                               height: length))
        
        nowDateLayer.frame = buttonFrame
        nowDateLayer.lineWidth = nowDateLayerLineWidth
        nowDateLayer.strokeColor = nowDateColor.cgColor
        nowDateLayer.fillColor = UIColor.clear.cgColor
        nowDateLayer.path = path.cgPath
        
        calendarView.layer.addSublayer(nowDateLayer)
    }
    
    private func reloadCalendar() {
        guard let monthDate = monthDate else {
            return
        }
        
        setWeekLabels()
        setYearMonthLabel(monthDate: monthDate)
        var components = calendar.dateComponents([.year, .month, .day, .weekday], from: monthDate)
        
        let firstDayOfWeek = components.weekday!
        guard let firstDate = calendar.date(from: components),
            let lastDayOfMonth = calendar.range(of: .day, in: .month, for: firstDate)?.count else {
            return
        }
        
        components.day = -1
        guard let lastMonthDate = calendar.date(from: components),
            let lastDayOfLastMonth = calendar.range(of: .day, in: .month, for: lastMonthDate)?.count else {
            return
        }
        
        let lastMonthDayCount = firstDayOfWeek - 1
        
        clearSelectView()
        clearNowDateLayer()
        let font = adjustButtonFont(rect: (dayButtons.first?.frame)!)
        for (index, dayButton) in dayButtons.enumerated() {
            components = calendar.dateComponents([.year, .month, .day, .weekday], from: monthDate)
            var day:Int = 0
            dayButton.titleLabel?.font = font
            if index < lastMonthDayCount {
                components.month = components.month! - 1
                day = lastDayOfLastMonth - (lastMonthDayCount - index) + 1
                dayButton.isEnabled = false
            } else if index < lastMonthDayCount + lastDayOfMonth {
                day = index - lastMonthDayCount + 1
                dayButton.isEnabled = true
            } else {
                components.month = components.month! + 1
                day = index - (lastMonthDayCount + lastDayOfMonth) + 1
                dayButton.isEnabled = false
            }
            dayButton.setTitle(String(day), for: .normal)
            dayButton.setTitle(String(day), for: .highlighted)
            dayButton.setTitle(String(day), for: .selected)
            dayButton.setTitle(String(day), for: .disabled)
            
            components.day = day
            let btnDate = calendar.date(from: components)
            
            if isSameDate(date1: btnDate, date2: selectedDate) {
                showSelectView(dayButton: dayButton)
                if dayButton.isEnabled {
                    dayButton.isSelected = true
                }
            } else {
                dayButton.isSelected = false
            }
            
            if isSameDate(date1: btnDate, date2: Date()) {
                showNowDateLayer(dayButton: dayButton)
            }
        }
    }
    
    private func setWeekLabels() {
        weekLabels.forEach{$0.font = adjustLabelFont(rect: $0.frame)}
        headerDateFormatter.locale = getLocale()
        for (index, label) in weekLabels.enumerated() {
            label.text = headerDateFormatter.shortWeekdaySymbols[index]
        }
    }
    
    private func setYearMonthLabel(monthDate: Date) {
        yearMonthLabel.font = adjustLabelFont(rect: yearMonthLabel.frame)
        headerDateFormatter.calendar = Calendar.current
        headerDateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMM",
                                                                  options: 0,
                                                                  locale: getLocale())
        yearMonthLabel.text = headerDateFormatter.string(from: monthDate)
    }
    
 
    private func isSameDate(date1: Date?, date2: Date?) -> Bool {
        if date1 == nil && date2 == nil {
            return true
        }
        
        guard let date1 = date1,
            let date2 = date2 else {
            return false
        }
        
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter.string(from: date1) == dateFormatter.string(from: date2)
    }
    
    private func getLocale() -> Locale {
        guard let langId = Locale.preferredLanguages.first else {
            return Locale.current
        }
        
        return Locale(identifier: langId)
    }
    
    @IBAction private func tappedDayButton(_ dayButton: UIButton) {
        guard let monthDate = monthDate else {
            return
        }
        
        clearSelectView()
        showSelectView(dayButton: dayButton)
        dayButtons.forEach{$0.isSelected = false}
        dayButton.isSelected = true
        
        var components = calendar.dateComponents([.year, .month, .day, .weekday], from: monthDate)
        components.day = Int(dayButton.currentTitle!)
        selectedDate = calendar.date(from: components)
        delegate?.calendarDataViewController(self, didSelectDate: selectedDate)
    }
    
    private func clearNowDateLayer() {
        nowDateLayer?.removeFromSuperlayer()
        nowDateLayer = nil
    }

    private func adjustButtonFont(rect: CGRect) -> UIFont {
        let length:CGFloat = (rect.width > rect.height) ? rect.height : rect.width
        let font = UIFont.systemFont(ofSize: length * 0.5)
        return font
    }
    
    private func adjustLabelFont(rect: CGRect) -> UIFont {
        let length:CGFloat = (rect.width > rect.height) ? rect.height : rect.width
        let font = UIFont.systemFont(ofSize: length * 0.5)
        return font
    }
}
