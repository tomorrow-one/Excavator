#
# Be sure to run `pod lib lint Excavator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Excavator'
  s.version          = '0.2.1'
  s.summary          = 'An extension over Apple Vision framework for extracting text from CIImage.'
  s.swift_version    = '5.0'
  s.description      = <<-DESC
  An extension over Apple Vision framework for extracting text from CIImage. IBAN and email extractors are supported out of the box.
                       DESC
  s.homepage         = 'https://github.com/tomorrow-one/Excavator'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tomorrow GmbH' => 'ios@tomorrow.one' }
  s.source           = { :git => 'https://github.com/tomorrow-one/Excavator.git',
                         :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.source_files = 'Excavator/Excavator/**/*'
  s.frameworks = 'CoreImage', 'Vision'
end
