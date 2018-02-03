#
# Be sure to run `pod lib lint POE.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'POE'
  s.version          = '0.2.5'
  s.summary          = 'POE Tor Onboarding Library'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
This pod contains all the stuff needed to enable a unified onboarding and connecting experience for
official Tor enabled open source apps.

It contains scenes to explain Tor a little, scenes to set up Tor bridges and a connecting scene,
which rotates nice images together with claims about how Tor can help your users.

This pod is prominently used in the OnionBrowser: https://github.com/mtigas/OnionBrowser

Written in Swift 3.
                       DESC

  s.homepage         = 'https://github.com/guardianproject/poe'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'BSD', :file => 'LICENSE' }
  s.author           = { 'tladesignz' => 'be@benjaminerhart.com' }
  s.source           = { :git => 'https://github.com/guardianproject/poe.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/guardianproject'

  s.ios.deployment_target = '8.0'

  s.source_files = 'POE/Classes/**/*.swift'
  
  s.resource_bundles = {
    'POE' => [
      'POE/Classes/*.xib',
      'POE/Assets/*.storyboard',
      'POE/Assets/*.xcassets',
      'POE/Assets/roboto/*.*',
      'POE/Assets/*.lproj/*.*',
    ]
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Localize', '~> 1.5'
  s.dependency 'KMPlaceholderTextView', '~> 1.3'
  s.dependency 'UIColor-HexRGB'
end
