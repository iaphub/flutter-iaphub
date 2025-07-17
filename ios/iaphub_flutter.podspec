#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint iaphub_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'iaphub_flutter'
  s.version          = '2.0.0'
  s.summary          = 'IAPHUB SDK for Flutter'
  s.description      = <<-DESC
  The easiest way to monetize your iOS and Android Flutter apps by selling in-app purchases. Sell subscriptions and other digital goods using our user-friendly SDK.
                         DESC
  s.homepage         = 'https://www.iaphub.com'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Iaphub' => 'support@iaphub.com' }
  s.source           = { :git => 'https://github.com/iaphub/flutter-iaphub.git', :tag => s.version.to_s }
  s.source_files     = 'Classes/**/*'
  s.platform         = :ios, '9.0'
  s.swift_versions   = ['5.0', '5.1']
  
  s.dependency 'Flutter'
  s.dependency "Iaphub", "4.6.5"

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
