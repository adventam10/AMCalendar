Pod::Spec.new do |s|
    s.name         = "AMCalendar"
    s.version      = "2.0"
    s.summary      = "AMCalendar is a calendar can select date."
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.homepage     = "https://github.com/adventam10/AMCalendar"
    s.author       = { "am10" => "adventam10@gmail.com" }
    s.source       = { :git => "https://github.com/adventam10/AMCalendar.git", :tag => "#{s.version}" }
    s.platform     = :ios, "9.0"
    s.requires_arc = true
    s.source_files = 'AMCalendarViewController/*.{swift}'
    s.resources    = 'AMCalendarViewController/*.xib'
    s.swift_version = "5.0"
end


