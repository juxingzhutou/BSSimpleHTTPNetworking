Pod::Spec.new do |s|
  s.name     = 'BSSimpleHTTPNetworking'
  s.version  = '0.0.1'
  s.summary = 'An simple networking api based on AFNetworking'
  s.license = { :type => 'MIT', :file => 'LICENCE' }
  s.homepage = 'https://github.com/juxingzhutou/BSSimpleHTTPNetworking'
  s.author = { 'juxingzhutou' => 'juxingzhutou@gmail.com' }

  s.platform = :ios
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

  s.source = { :git => "https://github.com/juxingzhutou/BSSimpleHTTPNetworking.git", :tag => 'v0.0.1' }
  s.source_files = "BSSimpleHTTPNetworking/*.{h,m}"
  s.public_header_files = "BSSimpleHTTPNetworking/BSNetworking.h"

  s.dependency "AFNetworking"

end
