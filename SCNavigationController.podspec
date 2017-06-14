Pod::Spec.new do |s|
  s.name     = 'SCNavigationController'
  s.version  = '1.1.2'
  s.platform = :ios
  s.ios.deployment_target = '5.0'

  s.summary  = 'SCNavigationController is an UINavigationController like container view controller built to provide and expose more features and control'
  s.description = <<-DESC
                  SCNavigationController is an UINavigationController like container view controller and was built to provide and expose more features and control.
                  It is especially helpful in customizing the push/pop animations through layouters and custom timing functions, and to know when those animations are finished through completion blocks.
                  DESC
  s.homepage = 'https://github.com/stefanceriu/SCNavigationController'
  s.author   = { 'Stefan Ceriu' => 'stefan.ceriu@yahoo.com' }
  s.social_media_url = 'https://twitter.com/stefanceriu'
  s.source   = { :git => 'https://github.com/stefanceriu/SCNavigationController.git', :tag => "v#{s.version}" }
  s.license      = { :type => 'MIT License', :file => 'LICENSE' }
  s.source_files = 'SCNavigationController/*'
  s.requires_arc = true
  s.frameworks = 'UIKit', 'QuartzCore', 'CoreGraphics', 'Foundation'

  s.dependency 'SCStackViewController', '~> 3.3.3'
end