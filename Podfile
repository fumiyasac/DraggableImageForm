platform :ios, '9.0'
swift_version = '3.0'

target 'DraggableImageForm' do
  use_frameworks!
  pod 'RealmSwift', '~> 2.5.1'
  pod 'Alamofire',  '~> 4.4.0'
  pod 'SwiftyJSON', '~> 3.1.4'
  pod 'Kingfisher'  '~> 3.6.1'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
