# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
source 'https://git.coding.net/sim_cai/simSpecs.git'
source 'https://github.com/CocoaPods/Specs.git'

def ThreeThingsPod

  pod 'IBAnimatable', '~> 3.1.1'
  pod 'FSCalendar', '~> 2.7.1'
  pod 'ThreeThingsPods', '~> 0.1.0'
  pod 'RealmThreeThings'

end

use_frameworks!

target 'ThreeThingsBeta' do

  ThreeThingsPod()

  target 'ThreeThingsBetaTests' do
      pod 'Quick', '~> 1.1.0'
      pod 'Nimble', '~> 6.0.1'
  end


end

target 'ThreeThings' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  ThreeThingsPod()

end
