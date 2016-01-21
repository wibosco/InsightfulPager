Pod::Spec.new do |s|

  s.name         = "InsightfulPager"
  s.version      = "0.0.1"
  s.summary      = "InsightfulPager is an alternative to UIPageViewController that fulfils a similar but provides more feedback."

  s.homepage     = "http://www.williamboles.me"
  s.license      = { :type => 'MIT', 
  					 :file => 'LICENSE.md' }
  s.author       = "William Boles"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/wibosco/InsightfulPager.git", 
  					 :branch => "master", 
  					 :tag => s.version }

  s.source_files  = "InsightfulPager/**/*.{h,m}"
  s.public_header_files = "InsightfulPager/**/*.{h}"
	
  s.requires_arc = true
  
end
