# LTHRadioButton

Slightly inspired by Google's material radio button.

The clip below has 3 sections: full speed, 25% and 10%, but after converting it to GIF, it actually made it longer, so the 10% part takes a really long time. [Here's][1] an mp4 link; try with Chrome if Safari doesn't work - for me it doesn't.

![][image-1]

## How to install

### Swift Package Manager

**NOTE**: _These instructions are intended for usage on Xcode 11 and higher. Xcode 11 is the first version of Xcode that integrates Swift Package Manager and makes it way easier to use than it was at the command line. If you are using older versions of Xcode, we recommend using CocoaPods._

1. Go to File > Swift Packages > Add Package Dependency...
2. Paste the URL to the `LTHRadioButton` repo on GitHub (https://github.com/rolandleth/LTHRadioButton.git) into the search bar, then hit the Next button:
3. Select what version you want to use, then hit next (Xcode will automatically suggest the current version Up to Next Major).
4. Select the `LTHRadioButton` library and then hit finish.
5. You're done!

#### CocoaPods

[CocoaPods][2] is a dependency manager for Cocoa projects. You can install it with the following terminal command:

```
gem install cocoapods
```

To integrate `LTHRadioButton` into your Xcode project using CocoaPods, specify it in your Podfile:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target '<Your Target Name>' do
  pod 'LTHRadioButton'
end
```

Then, run the following terminal command:

```
pod install
```

#### Manual

Drag `LTHRadioButton.swift` from the `source` folder into your Xcode project.

## How to use

The initializer takes up to 3 params: a `diameter`, a `selectedColor`, and a `deselectedColor`. All of them are optional:

- `diameter` defaults to `18`
- `selectedColor` defaults to a light blue
- `deselectedColor` defaults to `UIColor.lightGray`

It doesn't use Auto Layout internally, but after initialization it will have a proper size, so you can simply create constraints based on its `frame.width` and `frame.height`.

#### Properties

`selectedColor` and `deselectedColor` have been made publicly customizable for cases like a `tableView` with alternating row and radio colors, where the `tableView` might dequeue a cell with one color for displaying a cell with a different color.

`isSelected` - Indicates whether the radio button is selected.

`useTapGestureRecognizer` - Indicates whether a tap gesture recognizer should be added to the control when setting callbacks. This defaults to `true` just so that `onSelect` and `onDeselect` can add the gesture recognizer automatically, but the recognizer is **not** added by default.

- Settings this to `true` will also add the required `UITapGestureRecognizer` if needed.
- Settings this to `false` will also remove the `UITapGestureRecognizer` if it was previously added.

#### Methods

```swift
init(diameter: CGFloat = 18, selectedColor: UIColor? = nil, deselectedColor: UIColor? = nil) // Colors default internally if nil.
func select(animated: Bool = true) // Selects the radio button.
func deselect(animated: Bool = true) // Deselects the radio button.
```

### Callbacks

You can make use of the `onSelect` and `onDeselect` methods to add closures to be run when selecting/deselecting the control. Since these closures make most sense for taps and because there are no recognizers by default, these methods will also add one (and only one) `UITapGestureRecognizer` to the control to handle the taps; the closure calls happen right as the animations begin.

If you'd like to use the callbacks but don't need the tap gesture recognizer, you can set `useTapGestureRecognizer` to `false`.

### Example

```swift
let radioButton = LTHRadioButton(selectedColor: .red)
container.addSubview(radioButton)

radioButton.translatesAutoresizingMaskIntoConstraints = false
NSLayoutConstraint.activate([
  radioButton.centerYAnchor.constraint(equalTo: container.centerYAnchor),
  radioButton.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
  radioButton.heightAnchor.constraint(equalToConstant: radioButton.frame.height),
  radioButton.widthAnchor.constraint(equalToConstant: radioButton.frame.width)]
)

radioButton.onSelect {
  print("I'm selected.")
}

radioButton.onDeselect {
  print("I'm deselected.")
}

[...]

radioButton.select() // I'm selected.

[...]

radioButton.deselect(animated: false) // I'm deselected.
```

## Apps using this control

If you're using this control, I'd love hearing from you!

## License

Licensed under MIT. If you'd like (or need) a license without attribution, don't hesitate to [contact me][3].

[1]: https://rolandleth.com/images/radio-button/video.mp4
[2]: https://cocoapods.org
[3]: mailto:roland@hey.com
[image-1]: https://rolandleth.com/images/radio-button/gif.gif
