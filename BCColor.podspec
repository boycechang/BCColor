
Pod::Spec.new do |s|
  s.name     = 'BCColor'
  s.version  = '0.1.2'
  s.summary  = "A lightweight but powerful color kit (Swift)"

  s.license  = { :type => "MIT", :file => "LICENSE" }
  s.homepage = 'https://github.com/boycechang/BCColor'

  s.authors  = { 'Boyce Chang' =>
                 'boyce.chang89@gmail.com' }
  s.social_media_url = "https://github.com/boycechang"

  s.source   = { :git => 'https://github.com/boycechang/BCColor.git', :tag => '0.1.2' }
  s.source_files = 'BCColor/BCColor'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true

end
