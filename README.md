# PKSecurePin
Elegant Secure PIN with dynamic inputs digits in Swift

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

**Feature:**
* Ease to use
* Dynamic pins with or without confirmation pin based on configuration
* Accept only digit as input
* Restrict to enter 1 digit per input
* Auto jump to immediate next input on every insertion
* Auto jump to immediate previous input on every deletion
* Restrict the input or to select other PIN without entering the digit for current PIN

<img src="./demo.gif" width="200" alt="Screenshot" />
<img src="./iphone_demo.gif" width="200" alt="Screenshot" />

# Installation
### CocoaPods
In your `Podfile`:
```
pod "PKSecurePin"
```
### Manual
Copy the entire `PKSecurePin` folder which contains two swift files and add to your project
```
cp -rf PKSecurePin/ <to_your_project_dir>
```

# Usage
```swift
            // adopt the protocol
            class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, PKSecurePinControllerDelegate
            
            // create an instance of PKSecurePinViewController, with how many PIN, OTP or confirmation, position from top
            //NOTE: Please specify the correct value for topPos for the PIN text field w.r.t. to iPad & iPhone
            var pinViewC = PKSecurePinViewController.init(numberOfPins: 6, withconfirmation: true, topPos: 230)
            
            // PKSecurePinControllerDelegate methods implementation
            func didFinishSecurePin(pinValue: String) {
                //show the message if you want to display on success, else comment the below line
                pinViewC.showMessage(PKSecurePinError(errorString:"Success", errorCode: 200, errorIsHidden: false))
                //Go ahead with the business logic which you want to achieve with the PIN
            }
            
            // set the background color for PIN controller
            pinViewC.view.backgroundColor = UIColor.white
            
            //set the delegate
            pinViewC.delegate = self

            // create the pin navigation controller
            let pinNav = UINavigationController(rootViewController: pinViewC)

            // set the presentation style
            pinNav.modalPresentationStyle = .popover

            //pinview controller position
            pinViewC.preferredContentSize = CGSize(width: UIScreen.main.bounds.width * 0.5, height: 200)

            // create an instance for popover
            let popover = pinNav.popoverPresentationController
            popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
            popover?.sourceView = self.view

            //popover position
            popover?.sourceRect = CGRect(x: UIScreen.main.bounds.width * 0.5 - UIScreen.main.bounds.width * 0.25, y: UIScreen.main.bounds.height * 0.5 - 100, width: UIScreen.main.bounds.width * 0.5, height: 200)

            //present the pin navigation controller
            self.present(pinNav, animated: true, completion: nil)



