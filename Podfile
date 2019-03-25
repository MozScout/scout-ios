# Uncomment the next line to define a global platform for your project

platform :ios, '11.0'
use_frameworks!

source 'https://github.com/snipsco/Specs'
source 'https://github.com/CocoaPods/Specs.git'

target 'Scout' do

  pod 'Alamofire', '~> 4.7'
  pod 'AsyncSwift', '~> 2.0'
  pod 'SwiftyJSON', '~> 4.2'
  pod 'KeychainAccess', '~> 3.1'
  pod 'Kingfisher', '~> 4.10'
  pod 'SnipsPlatform'

  # UI components
  pod 'HexColors', '~> 6.0'
  pod 'DifferenceKit'

  pod 'Moya', '12.0.1'
  pod 'ReachabilitySwift', '4.3.0'
  pod 'SnapKit', '4.2.0'

  pod 'RxAtomic', '4.4.0'
  pod 'RxSwift', '4.4.0'
  pod 'RxCocoa', '4.4.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.name == 'SnipsPlatform'
                config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
        end
    end
end
