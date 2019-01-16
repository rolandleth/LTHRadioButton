//
//  LTHRadioButton.swift
//  LTHRadioButton
//
//  Created by Roland Leth on 17.11.2016.
//  Copyright © 2016 Roland Leth All rights reserved.
//

import UIKit

/// A radio button with a fill animation.
public class LTHRadioButton: UIView {
	
	/// The view used for the rippling effect.
	private let waveCircle   = UIView()
	/// The view used for the filling.
	private let circle       = UIView()
	/// The view used for the margin.
	private let innerCircle  = UIView()
	/// The color used for the selected state.
	@IBInspectable
	public var selectedColor = UIColor(red: 0.29, green: 0.56, blue: 0.88, alpha: 1.0) {
		willSet {
			innerCircle.layer.borderColor = newValue.cgColor
			waveCircle.layer.borderColor  = newValue.cgColor
		}
	}
	/// The color used for the deselected state.
	@IBInspectable
	public var deselectedColor = UIColor.lightGray {
		willSet {
			circle.layer.borderColor = newValue.cgColor
		}
	}
	/// A `Boolean` value that indicates whether the button is selected.
	public private(set) var isSelected = false
	/// A `Boolean` value that indicates whether the button should add a `UITapGestureRecognizer`.
	/// - Note: This defaults to `true` just so that `onSelect` and `onDeselect` can add the gesture recognizer automatically, but it is **not** added by default.
	/// - Settings this to `true` will also add the required `UITapGestureRecognizer` if needed.
	/// - Settings this to `false` will also remove the `UITapGestureRecognizer` if it was previously added.
	public var useTapGestureRecognizer = true {
		willSet {
			guard newValue else { return removeGestureRecognizer(tapGesture) }
			addTapGesture()
		}
	}
	
	/// The final width of the inner circle's border, used for filling.
	private var innerBorderWidth: CGFloat {
		return innerCircle.frame.width * 0.6
	}
	/// The percentage with which the innler circle will increase for the elastic filling effect.
	private let innerIncreaseDelta: CGFloat = 1.1
	/// The width of the inner circle after increasing for the elasting filling effect.
	private var innerIncreasedWidth: CGFloat {
		return innerCircle.frame.width * innerIncreaseDelta
	}
	
	/// The tap gesture that will handle the `onSelect`/`onDeselect` callbacks.
	private lazy var tapGesture: UITapGestureRecognizer = {
		let tg = UITapGestureRecognizer()
		
		tg.numberOfTapsRequired = 1
		tg.numberOfTouchesRequired = 1
		tg.addTarget(self, action: #selector(self.toggleState))
		
		return tg
	}()
	/// The closure that will be called when the control is selected.
	private var didSelect: () -> Void = { } {
		willSet {
			addTapGesture()
		}
	}
	/// The closure that will be called when the control is deselected.
	private var didDeselect: () -> Void = { } {
		willSet {
			addTapGesture()
		}
	}
	
	
	// MARK: - Callbacks
	
	/// Sets a closure that will be called when the control is selected.
	///
	/// - Important: Calling this will also add the required `UITapGestureRecognizer`, unless it was already added or `useTapGestureRecognizer` was set to `false`.
	/// - Parameter closure: The closure the be called.
	public func onSelect(execute closure: @escaping () -> Void) {
		didSelect = closure
	}
	
	/// Sets a closure that will be called when the control is deselected.
	///
	/// - Important: Calling this will also add the required `UITapGestureRecognizer`, unless it was already added or `useTapGestureRecognizer` was set to `false`.
	/// - Parameter closure: The closure the be called.
	public func onDeselect(execute closure: @escaping () -> Void) {
		didDeselect = closure
	}
	
	
	// MARK: - Select animations
	
	/// Initializes and returns the animation for filling the inner circle.
	private func innerBorderIncrease() -> CABasicAnimation {
		let borderWidth = CABasicAnimation(keyPath: "borderWidth")
		
		borderWidth.duration       = 0.2
		borderWidth.fromValue      = 0.0
		borderWidth.toValue        = innerBorderWidth
		borderWidth.timingFunction = CAMediaTimingFunction(name: .easeIn)
		borderWidth.fillMode       = .backwards
		borderWidth.beginTime      = layer.lth_currentMediaTime
		
		return borderWidth
	}
	
	/// Initializes and returns the animation group for increasing the inner circle,
	/// the first step in giving it an elastic effect.
	private func innerIncreaseGroup() -> CAAnimationGroup {
		let group = CAAnimationGroup()
		
		let bounds       = CABasicAnimation(keyPath: "bounds")
		bounds.fromValue = NSValue(cgRect: innerCircle.frame)
		bounds.toValue   = NSValue(cgRect: CGRect(
			x: 0, y: 0,
			width: innerIncreasedWidth, height: innerIncreasedWidth)
		)
		
		let cornerRadius       = CABasicAnimation(keyPath: "cornerRadius")
		cornerRadius.fromValue = innerCircle.layer.cornerRadius
		cornerRadius.toValue   = innerCircle.layer.cornerRadius * innerIncreaseDelta
		
		group.duration       = 0.1
		group.animations     = [bounds, cornerRadius]
		group.timingFunction = CAMediaTimingFunction(name: .easeOut)
		group.beginTime      = layer.lth_currentMediaTime + 0.23
		
		return group
	}
	
	/// Initializes and returns the animation group for decreasing the inner circle,
	/// the second step in giving it an elastic effect.
	private func innerDecreaseGroup() -> CAAnimationGroup {
		let group = CAAnimationGroup()
		
		let bounds = CABasicAnimation(keyPath: "bounds")
		bounds.toValue   = NSValue(cgRect: innerCircle.frame)
		bounds.fromValue = NSValue(cgRect: CGRect(
			x: 0, y: 0,
			width: innerIncreasedWidth, height: innerIncreasedWidth)
		)
		
		let cornerRadius       = CABasicAnimation(keyPath: "cornerRadius")
		cornerRadius.fromValue = innerCircle.layer.cornerRadius * innerIncreaseDelta
		cornerRadius.toValue   = innerCircle.layer.cornerRadius
		
		group.duration       = 0.15
		group.animations     = [bounds, cornerRadius]
		group.timingFunction = CAMediaTimingFunction(name: .easeOut)
		group.beginTime      = layer.lth_currentMediaTime + 0.31
		
		return group
	}
	
	/// Initializes and returns the animation for coloring the outer circle.
	private func circleBorderColor() -> CABasicAnimation {
		let borderColor = CABasicAnimation(keyPath: "borderColor")
		
		borderColor.duration       = 0.15
		borderColor.fromValue      = deselectedColor.cgColor
		borderColor.toValue        = selectedColor.cgColor
		borderColor.timingFunction = CAMediaTimingFunction(name: .linear)
		borderColor.fillMode       = .backwards
		borderColor.beginTime      = layer.lth_currentMediaTime + 0.28
		
		return borderColor
	}
	
	/// Initializes and returns the animation group for increasing the wave circle,
	/// giving it a pulsing effect.
	private func waveIncreaseGroup() -> CAAnimationGroup {
		let start = 0.21
		let delta = CGFloat(2.15)
		let width = waveCircle.frame.width * delta
		let group = CAAnimationGroup()
		
		let bounds       = CABasicAnimation(keyPath: "bounds")
		bounds.fromValue = NSValue(cgRect: waveCircle.frame)
		bounds.toValue   = NSValue(cgRect: CGRect(
			x: 0, y: 0,
			width: width, height: width)
		)
		
		let cornerRadius       = CABasicAnimation(keyPath: "cornerRadius")
		cornerRadius.fromValue = waveCircle.layer.cornerRadius
		cornerRadius.toValue   = waveCircle.layer.cornerRadius * delta
		
		group.duration       = 0.25
		group.animations     = [bounds, cornerRadius]
		group.timingFunction = CAMediaTimingFunction(name: .easeOut)
		group.beginTime      = layer.lth_currentMediaTime + start
		
		return group
	}
	
	/// Initializes and returns the animation for fading out the wave circle.
	private func waveAlphaDecrease() -> CABasicAnimation {
		let opacity = CABasicAnimation(keyPath: "opacity")
		
		opacity.duration       = 0.31
		opacity.fromValue      = 0.3
		opacity.toValue        = 0
		opacity.timingFunction = CAMediaTimingFunction(name: .easeOut)
		opacity.beginTime      = layer.lth_currentMediaTime + 0.26
		
		return opacity
	}
	
	/// Initializes and returns the animation for decreasing width of the wave circle,
	/// the final step in giving it a ripple effect.
	private func waveBorderDecrease() -> CABasicAnimation {
		let borderWidth = CABasicAnimation(keyPath: "borderWidth")
		
		borderWidth.duration       = 0.26
		borderWidth.fromValue      = frame.width * 0.3
		borderWidth.toValue        = 0
		borderWidth.timingFunction = CAMediaTimingFunction(name: .easeOut)
		borderWidth.beginTime      = layer.lth_currentMediaTime + 0.29
		
		return borderWidth
	}
	
	
	// MARK: - Deselect animations
	
	/// Initializes and returns the animation group for emptying the inner circle.
	private func innerDecreaseGroupReverse(duration: Double) -> CAAnimationGroup {
		let group = CAAnimationGroup()

		let borderWidth       = CABasicAnimation(keyPath: "borderWidth")
		borderWidth.fromValue = innerBorderWidth
		borderWidth.toValue   = 0.0
		
		let opacity       = CABasicAnimation(keyPath: "opacity")
		opacity.fromValue = 1.0
		opacity.toValue   = 0.0
		
		group.duration       = duration
		group.animations     = [borderWidth, opacity]
		group.timingFunction = CAMediaTimingFunction(name: .easeIn)
		group.beginTime      = layer.lth_currentMediaTime
		
		return group
	}
	
	/// Initializes and returns the animation group for decoloring the outer circle.
	private func circleBorderColorReverse(duration: Double) -> CABasicAnimation {
		let borderColor = CABasicAnimation(keyPath: "borderColor")
		
		borderColor.duration       = duration
		borderColor.fromValue      = selectedColor.cgColor
		borderColor.toValue        = deselectedColor.cgColor
		borderColor.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		borderColor.beginTime      = layer.lth_currentMediaTime
		
		return borderColor
	}
	
	
	// MARK: - Actions
	
	/// Sets the selected state of the control.
	///
	/// - Parameter animated: A `Boolean` value which determines whether the transition should be animated or not. Defaults to `true`.
	@objc(selectAnimated:)
	public func select(animated: Bool = true) {
		guard !isSelected else { return }
		isSelected = true
		
		innerCircle.layer.borderWidth = innerBorderWidth
		circle.layer.borderColor      = selectedColor.cgColor
		
		didSelect()
		
		guard animated else { return }
		
		innerCircle.layer.add(innerBorderIncrease(), forKey: "innerBorderWidth")
		innerCircle.layer.add(innerIncreaseGroup(), forKey: "innerIncreaseGroup")
		innerCircle.layer.add(innerDecreaseGroup(), forKey: "innerDecreaseGroup")
		
		circle.layer.add(circleBorderColor(), forKey: "circleBorderColor")
		
		waveCircle.layer.add(waveIncreaseGroup(), forKey: "innerDecreaseGroup")
		waveCircle.layer.add(waveAlphaDecrease(), forKey: "outerAlphaDecrease")
		waveCircle.layer.add(waveBorderDecrease(), forKey: "outerBorderDecrease")
	}
	
	/// Sets the deselected state of the control.
	///
	/// - Parameter animated: A `Boolean` value which determines whether the transition should be animated or not. Defaults to `true`.
	@objc(deselectAnimated:)
	public func deselect(animated: Bool = true) {
		guard isSelected else { return }
		isSelected = false
		
		removeAnimations()
		setDeselectedEndValues()
		didDeselect()
		
		guard animated else { return }
		
		let duration = 0.2
		innerCircle.layer.add(innerDecreaseGroupReverse(duration: duration), forKey: "innerDecreaseGroupReverse")
		circle.layer.add(circleBorderColorReverse(duration: duration), forKey: "circleBorderColorReverse")
	}
	
	/// Sets the end values for the deselected state.
	private func setDeselectedEndValues() {
		innerCircle.layer.borderWidth = 0
		circle.layer.borderColor      = deselectedColor.cgColor
	}
	
	/// Removes all animations.
	private func removeAnimations() {
		waveCircle.layer.removeAllAnimations()
		circle.layer.removeAllAnimations()
		innerCircle.layer.removeAllAnimations()
	}
	
	/// Toggles between selected and deselected states.
	@objc private func toggleState() {
		guard isSelected else { return select() }
		
		deselect()
	}
	
	/// Adds the `UITapGestureRecognizer`.
	private func addTapGesture() {
		guard useTapGestureRecognizer else { return }
		guard gestureRecognizers?.contains(tapGesture) != true else { return }
		
		addGestureRecognizer(tapGesture)
	}
	
	
	// MARK: - Init
	
	/// Initializes and returns a radio button with a diameter, a selected color and a deselected color.
	///
	/// - Parameters:
	///   - diameter: A constant, indicating the diameter. Optional, defaults to `18`.
	///   - selectedColor: The `UIColor` used for the selected state. Optional, defaults to a light blue.
	///   - deselectedColor: The `UIColor` used for the deselected state. Optional, defaults to `.lightGray`.
	public init(diameter: CGFloat = 18, selectedColor: UIColor? = nil, deselectedColor: UIColor? = nil) {
		let size = CGSize(width: diameter, height: diameter)
		super.init(frame: CGRect(origin: .zero, size: size))
		commonInit(diameter: diameter, selectedColor: selectedColor, deselectedColor: deselectedColor)
	}
	
	/// Called when a radio button is loaded from a xib. `selectedColor` and `deselectedColor` can be either added as *User Defined Runtime Attributes*, or set after initialization.
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		commonInit(diameter: frame.size.width, selectedColor: nil, deselectedColor: nil)
	}
	
	/// Performs the initialization of the radio button.
	///
	/// - Parameters:
	///   - diameter: A constant, indicating the diameter.
	///   - selectedColor: The `UIColor` used for the selected state, defaults to a light blue if `nil`.
	///   - deselectedColor: The `UIColor` used for the deselected state, defaults to `.lightGray` if `nil`.
	private func commonInit(diameter: CGFloat, selectedColor: UIColor?, deselectedColor: UIColor?) {
		let innerCircleDiameter = diameter / 1.6
		let radius = diameter * 0.5
		let center = CGPoint(x: radius, y: radius)
		
		backgroundColor      = .clear
		self.selectedColor   = selectedColor ?? self.selectedColor
		self.deselectedColor = deselectedColor ?? self.deselectedColor
		
		addSubview(circle)
		circle.backgroundColor    = .clear
		circle.layer.cornerRadius = radius
		circle.layer.borderColor  = self.deselectedColor.cgColor
		circle.layer.borderWidth  = diameter * 0.1
		circle.frame.size         = CGSize(width: diameter, height: diameter)
		circle.center             = center
		
		addSubview(innerCircle)
		innerCircle.backgroundColor    = .clear
		innerCircle.layer.cornerRadius = innerCircleDiameter * 0.5
		innerCircle.layer.borderColor  = self.selectedColor.cgColor
		innerCircle.layer.borderWidth  = 0
		innerCircle.frame.size         = CGSize(width: innerCircleDiameter, height: innerCircleDiameter)
		innerCircle.center             = center
		
		addSubview(waveCircle)
		waveCircle.backgroundColor    = .clear
		waveCircle.layer.cornerRadius = innerCircle.layer.cornerRadius
		waveCircle.layer.borderColor  = self.selectedColor.cgColor
		waveCircle.layer.borderWidth  = 0
		waveCircle.alpha              = 0
		waveCircle.frame.size         = innerCircle.frame.size
		waveCircle.center             = center
	}
	
}

fileprivate extension CALayer {
	
	/// Converts `CACurrentMediaTime()` to the layer's local time.
	///
	/// There seems to be an issue where over-time animations can get delayed. The delay can be multiple seconds and forever-growing and this is due to the fact that each `CALayer` and `CAAnimation` instance has its own local concept of time, which may differ from global time — `CACurrentMediaTime()` is global.
	///
	/// - Authors:
	///     - Thanks to [@alexandre-g](https://github.com/alexandre-g) for opening this [issue](https://github.com/rolandleth/LTHRadioButton/issues/6) and helping find the fix for it.
	///     - Thanks to [@kgaidis](https://github.com/kgaidis) for his fix in [this pull request](https://github.com/airbnb/lottie-ios/pull/618) for Lottie.
	var lth_currentMediaTime: CFTimeInterval {
		return convertTime(CACurrentMediaTime(), from: nil)
	}
	
}
