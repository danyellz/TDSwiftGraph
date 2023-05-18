  source 'https://github.com/CocoaPods/Specs.git'

  # ignore all warnings from all pods
  inhibit_all_warnings!

  #use swift frameworks
  use_frameworks!

  # Pods for TDSwiftGraph
  project ‘TDSwiftGraph’

  target 'TDSwiftGraph' do
  
    pod ‘SteviaLayout’
    pod ‘CorePlot’

  target 'TDSwiftGraphTests’ do
    inherit! :search_paths

    pod 'Quick', :git => 'https://github.com/Quick/Quick.git'
    pod 'Nimble', :git => 'https://github.com/Quick/Nimble.git'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
