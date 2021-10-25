# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'iOS Project Test' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
	pod 'UPCarouselFlowLayout'

  # Pods for iOS Project Test

  target 'iOS Project TestTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'iOS Project TestUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
        end
    end
end
