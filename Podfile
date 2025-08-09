# Uncomment the next line to define a global platform for your project
#source 'https://github.com/CocoaPods/Specs.git'
def custom_pods
  pod 'Alamofire', '5.9'
  pod 'ObjectMapper'
  pod 'SalahUtility', :git => 'https://github.com/salah-mohammed/SalahUtility.git'
  pod 'AlamofireObjectMapper', :git =>'https://github.com/salah-mohammed/AlamofireObjectMapper.git'
  pod 'AppTexts', :git => 'https://github.com/salah-mohammed/AppTexts.git'
  
  pod 'RealmSwift'
  pod 'ObjectMapper+Realm'#,:git =>'https://github.com/salah-mohammed/ObjectMapper-Realm.git'
  pod 'DateToolsSwift'
end

target 'GeneralKit' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # Pods for GeneralKit
  custom_pods


end

target 'GeneralKitExample' do
  platform :ios, '13.0'
  use_frameworks!
  custom_pods

end
target 'GeneralKitUIKitExample' do
  platform :ios, '13.0'
  use_frameworks!
  custom_pods
  pod 'MBProgressHUD'
end


target 'GeneralKitSwiftUIMacOsExample' do
  platform :osx, '13.2'
  use_frameworks!
  custom_pods
end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if Gem::Version.new('11.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
      end
      if Gem::Version.new('13.3') > Gem::Version.new(config.build_settings['MACOSX_DEPLOYMENT_TARGET'])
        config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '13.2'
      end
    end
  end
end
