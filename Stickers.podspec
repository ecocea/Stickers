#
# Be sure to run `pod lib lint Stickers.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Stickers'
  s.version          = '0.2.8'
  s.summary          = 'Swift pod to add stickers on your images!'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Swift pod to add stickers on your images ! Setup with urls or images. '

  s.homepage         = 'https://github.com/ecocea/Stickers'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ecocea' => 'asuard@ecocea.com' }
  s.source           = { :git => 'https://github.com/ecocea/Stickers.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11'

  s.source_files = 'Stickers/Classes/**/*'
  s.resources = 'Stickers/*.{storyboard,xib,xcassets,json,imageset,png}'
  s.resource_bundles = {
      'Stickers' => ['Stickers/*.{storyboard,xib,xcassets,json,imageset,png}']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Kingfisher', '~> 5.2.0'
  s.dependency 'NVActivityIndicatorView', '~> 4.7.0'
end
