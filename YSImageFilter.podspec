Pod::Spec.new do |s|
  s.name = 'YSImageFilter'
  s.version = '0.1.6'
  s.summary = 'YSImageFilter'
  s.homepage = 'https://github.com/yusuga/YSImageFilter'
  s.license = 'MIT'
  s.author = 'Yu Sugawara'
  s.source = { :git => 'https://github.com/yusuga/YSImageFilter.git', :tag => s.version.to_s }
  s.platform = :ios, '6.0'
  s.ios.deployment_target = '6.0'
  s.source_files = 'Classes/YSImageFilter/*.{h,m}'
  s.requires_arc = true
  
  s.compiler_flags = '-fmodules'
end