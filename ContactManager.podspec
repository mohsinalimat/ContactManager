#
# Be sure to run `pod lib lint ContactManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ContactManager'
  s.version          = '0.1.1'
  s.summary          = 'ContactManager for access for getting contacts.'

  s.description      = <<-DESC
ContactManager for access for getting contacts,Fetch Contacts,Search Contact,Add Contact,Update Contact,Delete Contact,Create Group.
                       DESC

  s.homepage         = 'https://github.com/mspvirajpatel/ContactManager'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Viraj Patel' => 'mspviraj@hotmail.com' }
  s.source           = { :git => 'https://github.com/mspvirajpatel/ContactManager.git', :tag => s.version }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ContactManager/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ContactManager' => ['ContactManager/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
