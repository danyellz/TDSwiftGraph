  # ignore all warnings from all pods
  inhibit_all_warnings!

  use_frameworks!

  # Pods for TDSwiftGraph
  project ‘TDSwiftGraph’

  target 'TDSwiftGraph' do
  
    pod ‘SteviaLayout’
    pod ‘CorePlot’

  target 'TDSwiftGraphTests’ do
    inherit! :search_paths

    # Tests
    pod 'Quick'
    pod 'Nimble'

  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
