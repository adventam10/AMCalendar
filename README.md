# AMCalendar

![Pod Platform](https://img.shields.io/cocoapods/p/AMCalendar.svg?style=flat)
![Pod License](https://img.shields.io/cocoapods/l/AMCalendar.svg?style=flat)
[![Pod Version](https://img.shields.io/cocoapods/v/AMCalendar.svg?style=flat)](http://cocoapods.org/pods/AMCalendar)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

`AMCalendar` is a calendar can select date.

## Demo

![calendar](https://user-images.githubusercontent.com/34936885/34912087-a163b070-f91a-11e7-818f-1584ce3c00c2.gif)

## Usage

```swift
let calendar =
AMCalendarRootViewController.setCalendar(onView: view,
parentViewController: self,
selectedDate: Date(),
delegate: self)
```

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

