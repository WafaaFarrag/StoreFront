source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '15.0'

target 'StoreFront' do
  use_frameworks!
  
  
  pod 'RxSwift', '~> 6.5'
  pod 'RxCocoa', '~> 6.5'
  pod 'RxDataSources', '~> 5.0'


  pod 'Moya/RxSwift', '~> 15.0'


  pod 'SwiftMessages', '~> 9.0'
  pod 'Kingfisher', '~> 7.0'


  pod 'ReachabilitySwift', '~> 5.0'
  
  pod 'SkeletonView'

end


post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|

      config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
