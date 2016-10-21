# LTHRadioButton

Slightly inspired by Google's material radio button. 

The clip below has 3 sections: full speed, 25% and 10%, but after converting it to GIF, it actually made it longer, so the 10% part takes a really long time 😄. [Here's](https://rolandleth.com/assets/radio-button/video.mp4) an mp4 link; try with Chrome if Safari doesn't work - for me it doesn't.

![](https://rolandleth.com/assets/radio-button/gif.gif)

## How to use

The initializer takes up to 3 params: a `radius`, a `selectedColor`, and a `deselectedColor`. All of them are optional:

* `radius` defaults to `18`
* `selectedColor` defaults to a light blue
* `deselectedColor` defaults to `UIColor.lightGray`

It doesn't use Auto Layout internally, but after initialization it will have a proper size, so you can simply create constraints based on its `frame.width` and `frame.height`.

#### Properties

`selectedColor` and `deselectedColor` have been made publicly customizable for cases like a `tableView` with alternating row and radio colors, where the `tableView` might dequeue a cell with one color for displaying a cell with a different color.

`isSelected` - Indicates whether the radio button is selected.

#### Methods

```swift
init(radius: CGFloat = 18, selectedColor: UIColor? = nil, deselectedColor: UIColor? = nil) // Colors default internally if nil.
func select(animated: Bool = true) // Selects the radio button.
func deselect(animated: Bool = true) // Deselects the radio button.
```

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

[...]

radioButton.select()

[...]

radioButton.deselect(animated: false)
```

## Apps using this control

If you're using this control, I'd love hearing from you!  

## License
Licensed under MIT. If you'd like (or need) a license without attribution, don't hesitate to [contact me](mailto:roland@leth.ro).
