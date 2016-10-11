Pod::Spec.new do |spec|
  spec.name = "CardsStack"
  spec.version = "0.2.1"
  spec.summary = "UICollectionView turned to awesome set of cards"
  spec.homepage = "https://github.com/priteshrnandgaonkar/CardsStack"
  spec.license = { type: 'MIT', file: 'LICENSE.md' }
  spec.authors = { "Pritesh Nandgaonkar" => 'prit.nandgaonkar@gmail.com' }
  spec.social_media_url = "https://twitter.com/prit91"

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/priteshrnandgaonkar/CardsStack.git", tag: "0.2.1" }
  spec.source_files = "CardsStack/**/*.{h,swift}"
end
