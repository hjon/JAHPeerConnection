#
#  Be sure to run `pod spec lint JAHPeerConnection.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "JAHPeerConnection"
  s.version      = "1.0.0"
  s.summary      = "A block-based API for RTCPeerConnection from webrtc.org."
  s.homepage     = "https://github.com/hjon/JAHPeerConnection"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = "Jon Hjelle"
  s.social_media_url   = "http://twitter.com/hjon"

  s.source       = { :git => "https://github.com/hjon/JAHPeerConnection.git", :tag => "1.0.0" }
  s.source_files  = "JAHPeerConnection.h", "JAHPeerConnection.m"

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.8'

  s.requires_arc = true
  s.dependency "libjingle_peerconnection"

end
