#
# Be sure to run `pod lib lint TomorrowIbanScanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TomorrowIbanScanner'
  s.version          = '0.1.3'
  s.summary          = 'A set of classes which recognize and extract IBAN from an image.'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This CocoaPod provides the ability to extract an IBAN or email from a given image. It includes some IBAN-specific validation rules so you will need no boilerplate for that.
                       DESC

  s.homepage         = 'https://github.com/PavelStepanovTomorrow' #FIXME
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PavelStepanovTomorrow' => 'pavel@tomorrow.one' } #fixme
  s.source           = { :git => 'https://github.com/PavelStepanovTomorrow/TomorrowIbanScanner.git', :tag => s.version.to_s } #FIXME
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'TomorrowIbanScanner/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TomorrowIbanScanner' => ['TomorrowIbanScanner/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
