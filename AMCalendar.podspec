Pod::Spec.new do |s|
    s.name         = "AMCalendar"
    s.version      = "1.0"
    s.summary      = "It can display chart."
    s.license      = { :type => 'MIT', :file => 'LICENSE' }
    s.homepage     = "https://github.com/adventam10/AMCalendar"
    s.author       = { "am10" => "adventam10@gmail.com" }
    s.source       = { :git => "https://github.com/adventam10/AMCalendar.git", :tag => "#{s.version}" }
    s.platform     = :ios, "9.0"
    s.requires_arc = true
    s.source_files = 'AMCalendarViewController/*.{swift}'
    s.resources    = 'AMCalendarViewController/*.xib'
    s.swift_version = "4.0"
end


