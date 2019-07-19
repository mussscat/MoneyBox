source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.0'
use_frameworks!

#Pod groups

def ui_pods
  pod 'MBProgressHUD'
  pod 'TagListView'
  pod 'IGListKit', '~> 3.0'
  pod 'Texture'
  pod 'Texture/IGListKit'
  pod 'SnapKit', '~> 5.0.0'
end

def networking_pods
  pod 'Moya', '~> 13.0'
  pod 'Alamofire', '~> 4.1'
end

def service_pods
  pod 'PromiseKit'
  pod 'SwiftyJSON'
  pod 'EasyDi'
end

#Targets

target 'MoneyBox' do
  ui_pods
  networking_pods
  service_pods
end
