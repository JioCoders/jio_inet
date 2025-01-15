#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint jio_inet.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'jio_inet'
  s.version          = '1.1.1'
  s.summary          = 'Pod for flutter plugin.'
  s.description      = <<-DESC
Flutter plugin to check the current connection and listener on connection changed.
                       DESC
  s.homepage         = 'https://github.com/jiocoders/jio_inet/'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Jiocoders' => 'jiocoders@gmail.com' }
#   s.source           = { :path => '.' }
  s.source           = { :git => 'https://github.com/jiocoders/jio_inet.git', :tag => s.version.to_s }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.requires_arc     = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'jio_inet_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
