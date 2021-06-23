#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run 'pod lib lint facebook_login.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'facebook_login'
  s.version          = '1.0.0'
  s.summary          = 'Flutter plugin for Facebook Login.'
  s.description      = <<-DESC
Flutter plugin for Facebook Login.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  s.static_framework = true
  s.subspec 'vendor' do |sp|
    sp.dependency 'FBSDKLoginKit', '~> 9.0.1'
  end
  
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
