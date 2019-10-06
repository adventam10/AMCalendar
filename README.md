# AMCalendar

![Pod Platform](https://img.shields.io/cocoapods/p/AMCalendar.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/AMCalendar.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/AMCalendar.svg?style=flat)](http://cocoapods.org/pods/AMCalendar)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`AMCalendar` is a calendar can select date.

## Demo

![calendar](https://user-images.githubusercontent.com/34936885/34912087-a163b070-f91a-11e7-818f-1584ce3c00c2.gif)

## Usage

Create calendar.

```swift
let calendar =
AMCalendar.setCalendar(onView: view, parentViewController: self,
                       selectedDate: Date(), delegate: self)
```

Conform to the protocol in the class implementation.

```swift
func calendar(_ calendar: AMCalendar, didSelectDate date: Date?) { 
    // use selected date here
}
```

### Customization
`AMCalendar` can be customized via the following properties.

```swift
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
```

sample

```swift
calendar.headerColor = .purple
calendar.monthTextColor = .yellow
calendar.defaultDateTextColor = .orange
calendar.disabledDateTextColor = .brown
calendar.sundayTextColor = .green
calendar.saturdayTextColor = .cyan
calendar.selectedDateTextColor = .blue
calendar.selectedDateColor = .magenta
calendar.nowDateColor = .black
calendar.locale = Locale(identifier: "ja_JP")
```

<img width="260" alt="calendar" src="https://user-images.githubusercontent.com/34936885/66266249-09786b00-e85d-11e9-896b-7aa53a070642.png">

## Installation

### CocoaPods

Add this to your Podfile.

```ogdl
pod 'AMCalendar'
```

### Carthage

Add this to your Cartfile.

```ogdl
github "adventam10/AMCalendar"
```

## License

MIT

