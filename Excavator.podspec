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

# This description is used to generate tags and improve search results. FIXME
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This CocoaPod provides the ability to extract an IBAN or email from a given image. It includes some IBAN and email specific validation rules so you will need no boilerplate for that.
                       DESC

  s.homepage         = 'https://github.com/tomorrow-one/Excavator'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2' #TODO: we have to find out, what happens with them
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Tomorrow GmbH' => 'ios@tomorrow.one' }
  s.source           = { :git => 'https://github.com/tomorrow-one/Excavator.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'

  s.source_files = 'Excavator/Excavator/**/*'
  
  # s.resource_bundles = {
  #   'Excavator' => ['Excavator/Assets/*.png']
  # }

  s.frameworks = 'CoreImage', 'Vision'
end
