#
# Be sure to run `pod lib lint Excavator.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Excavator'
  s.version          = '0.2.0'
  s.summary          = 'A set of classes which recognize and extract IBAN or email from an image using Vision framework from Apple.'
  s.swift_version    = '5.0'

# This description is used to generate tags and improve search results. FIXME
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  This CocoaPod provides the ability to extract an IBAN or email from a given image. It includes some IBAN and email specific validation rules so you will need no boilerplate for that.
                       DESC

  s.homepage         = 'https://github.com/PavelStepanovTomorrow' #TODO: FIXME
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2' #TODO: we have to find out, what happens with them
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'PavelStepanovTomorrow' => 'pavel@tomorrow.one' } #TODO: fixme
  s.source           = { :git => 'https://github.com/PavelStepanovTomorrow/Excavator.git', :tag => s.version.to_s } #TODO: FIXME
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'Excavator/Excavator/**/*'
  
  # s.resource_bundles = {
  #   'Excavator' => ['Excavator/Assets/*.png']
  # }

  s.frameworks = 'CoreImage', 'Vision'
end
