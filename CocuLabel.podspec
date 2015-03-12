Pod::Spec.new do |s|

  s.name         = "CocuLabel"
  s.version      = "0.0.1"
  s.summary      = "CocuLabel is subclass of UILabel that changes text color optimaized back view."
  s.description  = <<-DESC
                   We often have a chance to put labels on an image.
                   Then we may not decide the color of the label, not to be tinged in the image.
                   CocuLabel is a label that changes the text color optimaized back view.
                   DESC
  s.homepage     = "https://github.com/ushisantoasobu/CocuLabel"
  s.screenshots  = "https://github.com/ushisantoasobu/CocuLabel/blob/master/cocu_demo.gif?raw=true"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "ushisantoasobu" => "babblemann.shunsee@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ushisantoasobu/CocuLabel.git", :tag => s.version }
  s.source_files  = "CocuLabel/*.{swift}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

end
