# Uncomment the next line to define a global platform for your project
#source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '13.0'

def custom_pods
  pod 'Alamofire', '5.0.0-rc.2'
  pod 'ObjectMapper'
  pod 'SalahUtility', :git => 'https://github.com/salah-mohammed/SalahUtility.git'
  pod 'AlamofireObjectMapper'
  pod 'AppTexts', :git => 'https://github.com/salah-mohammed/AppTexts.git'
end

target 'GeneralKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for GeneralKit
  custom_pods


end

target 'GeneralKitExample' do
  use_frameworks!
  custom_pods

end
target 'GeneralKitUIKitExample' do
  use_frameworks!
  custom_pods
  pod 'MBProgressHUD'
end
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if Gem::Version.new('11.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
    end
  end
end
