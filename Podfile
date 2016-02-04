platform :ios, '8.0'
source 'https://github.com/CocoaPods/Specs.git'

xcodeproj 'Kabbalah.xcodeproj'

def new_pods
    pod "AFNetworking", "~> 2.0"
    pod 'Reachability', '~> 3.2'
    pod 'DZNEmptyDataSet'
    pod 'XMLDictionary', '1.4'
    pod 'Appirater_ios8', '~> 3.0'
    pod 'MBProgressHUD', '~> 0.9'
    pod 'Fabric', '~> 1.6'
end

def analytic_pods
	pod 'Localytics',  '~> 3.6'
end

target 'Kabbalah' do
	new_pods
	analytic_pods
end