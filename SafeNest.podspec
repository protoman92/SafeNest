Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'
  s.name = "SafeNest"
  s.summary = "Safe nest for all the swifties."
  s.requires_arc = true
  s.version = "1.0.0"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Hai Pham" => "swiften.svc@gmail.com" }
  s.homepage = "https://github.com/protoman92/SafeNest.git"
  s.source = { :git => "https://github.com/protoman92/SafeNest.git", :tag => "#{s.version}"}
  s.dependency 'SwiftFP/Main'

  s.subspec 'Main' do |m|
    m.source_files = "SafeNest/**/*.{swift}"
  end
end
