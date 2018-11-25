# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SafeNest' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  # use_frameworks!

  # Pods for SafeNest
  pod 'SwiftFP/Main', git: 'https://github.com/protoman92/SwiftFP.git'

  target 'SafeNestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'SafeNestDemo' do
    inherit! :search_paths
    use_modular_headers!
    
    pod 'HMReactiveRedux', git: 'https://github.com/protoman92/HMReactiveRedux-Swift', subspecs: [
      "Main",
      "Rx"
    ]
    
    pod 'RxDataSources'
    pod 'RxCocoa'
  end
  
end
