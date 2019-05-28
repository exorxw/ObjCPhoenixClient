#
# Be sure to run `pod lib lint ObjCPhoenixClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ObjCPhoenixClient'
  s.version          = '0.2.0'
  s.summary          = 'Phoenix Framework Channel Client'

  s.description      = <<-DESC
                        Phoenix Client allows ObjC based application to connect to Phoenix Framework channels over websocket.
                        DESC

  s.homepage         = 'https://github.com/exorxw/ObjCPhoenixClient'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '362922604@qq.com' => '362922604@qq.com' }
  s.source           = { :git => 'https://github.com/exorxw/ObjCPhoenixClient.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ObjCPhoenixClient/Classes/**/*'
  s.dependency 'SocketRocket', '0.5.1'
  
  # s.resource_bundles = {
  #   'ObjCPhoenixClient' => ['ObjCPhoenixClient/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
