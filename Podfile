platform :ios, '10.0'
use_frameworks!

target 'MVCProject' do
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'ObjectMapper'
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'RxDataSources'
    pod 'SDWebImage'
    pod 'RxKeyboard'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
