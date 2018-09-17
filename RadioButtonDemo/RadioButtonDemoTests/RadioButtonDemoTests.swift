//
//  RadioButtonDemoTests.swift
//  RadioButtonDemoTests
//
//  Created by Roland Leth on 03.12.2016.
//  Copyright © 2016 Roland Leth. All rights reserved.
//

import XCTest
import RadioButtonDemo

class RadioButtonDemoTests: XCTestCase {
	
	private let selectedColor = UIColor(red: 0.29, green: 0.56, blue: 0.88, alpha: 1.0)
	private lazy var mirror: Mirror = Mirror(reflecting: self.radioButton!)
	private var radioButton: LTHRadioButton!
	
	
	// MARK: -
	
	func testInitWithDefaultValues() {
		radioButton = LTHRadioButton()
		
		XCTAssertNotNil(radioButton)
		XCTAssertEqual(radioButton.selectedColor, selectedColor)
		XCTAssertEqual(radioButton.deselectedColor, .lightGray)
		XCTAssertEqual(radioButton.frame.size, CGSize(width: 18, height: 18))
	}
	
	func testInitWithParameters() {
		let selectedColor = UIColor.red
		let deselectedColor = UIColor.blue
		let diameter: CGFloat = 20
		
		radioButton = LTHRadioButton(diameter: diameter,
		                             selectedColor: selectedColor,
		                             deselectedColor: deselectedColor)
		
		XCTAssertNotNil(radioButton)
		XCTAssertEqual(radioButton.selectedColor, selectedColor)
		XCTAssertEqual(radioButton.deselectedColor, deselectedColor)
		XCTAssertEqual(radioButton.frame.size, CGSize(width: diameter, height: diameter))
	}
	
	func testXibLoading() {
		radioButton = Bundle.main
			.loadNibNamed("RadioButton", owner: self, options: nil)?
			.first as? LTHRadioButton
		
		let diameter: CGFloat = 30
		
		XCTAssertNotNil(radioButton, "Failed to load xib.")
		XCTAssertEqual(radioButton.selectedColor, UIColor.blue)
		XCTAssertEqual(radioButton.deselectedColor, UIColor.red)
		XCTAssertEqual(radioButton.frame.size, CGSize(width: diameter, height: diameter))
		
		// These, in conjunction with `testCircles`, are enough to assert that `commonInit` was properly ran.
		mirror.children.forEach {
			switch $0.label {
			case "waveCircle"?:
				guard let waveCircle = $0.value as? UIView else { return XCTFail() }
				XCTAssertEqual(waveCircle.layer.borderColor, UIColor.blue.cgColor)
			case "innerCircle"?:
				guard let innerCircle = $0.value as? UIView else { return XCTFail() }
				XCTAssertEqual(innerCircle.layer.borderColor, UIColor.blue.cgColor)
			case "circle"?:
				guard let circle = $0.value as? UIView else { return XCTFail() }
				XCTAssertEqual(circle.layer.cornerRadius, diameter * 0.5)
				XCTAssertEqual(circle.layer.borderColor, UIColor.red.cgColor)
				XCTAssertEqual(circle.layer.borderWidth, diameter * 0.1)
			default: return
			}
		}
	}
	
	func testCircles() {
		radioButton = LTHRadioButton()
		
		let diameter: CGFloat = 18
		let innerDiameter: CGFloat = diameter / 1.6
		let innerSize = CGSize(width: innerDiameter, height: innerDiameter)
		let innerCornerRadius: CGFloat = innerDiameter * 0.5
		
		mirror.children.forEach {
			switch $0.label {
			case "innerIncreaseDelta"?:
				XCTAssertEqual($0.value as? CGFloat, 1.1)
			case "waveCircle"?:
				guard let waveCircle = $0.value as? UIView else { return XCTFail() }
				XCTAssertEqual(waveCircle.layer.cornerRadius, innerCornerRadius)
				XCTAssertEqual(waveCircle.layer.backgroundColor, UIColor.clear.cgColor)
				XCTAssertEqual(waveCircle.layer.borderColor, selectedColor.cgColor)
				XCTAssertEqual(waveCircle.layer.borderWidth, 0)
				XCTAssertEqual(waveCircle.alpha, 0)
				XCTAssertEqual(waveCircle.frame.size, innerSize)
				XCTAssertEqual(waveCircle.center, radioButton.center)
			case "innerCircle"?:
				guard let innerCircle = $0.value as? UIView else { return XCTFail() }
				XCTAssertEqual(innerCircle.layer.cornerRadius, innerCornerRadius)
				XCTAssertEqual(innerCircle.layer.backgroundColor, UIColor.clear.cgColor)
				XCTAssertEqual(innerCircle.layer.borderColor, selectedColor.cgColor)
				XCTAssertEqual(innerCircle.layer.borderWidth, 0)
				XCTAssertEqual(innerCircle.frame.size, innerSize)
				XCTAssertEqual(innerCircle.center, radioButton.center)
			case "circle"?:
				guard let circle = $0.value as? UIView else { return XCTFail() }
				XCTAssertEqual(circle.layer.cornerRadius, diameter * 0.5)
				XCTAssertEqual(circle.layer.backgroundColor, UIColor.clear.cgColor)
				XCTAssertEqual(circle.layer.borderColor, UIColor.lightGray.cgColor)
				XCTAssertEqual(circle.layer.borderWidth, diameter * 0.1)
				XCTAssertEqual(circle.center, radioButton.center)
			default: return
			}
		}
	}
	
	func testSelectedDeselectedStates() {
		radioButton = LTHRadioButton()
		
		radioButton.select(animated: false)
		testState(selected: true)
		
		radioButton.deselect(animated: false)
		testState(selected: false)
	}
	
	func testProperties() {
		radioButton = LTHRadioButton()
		
		let expected: Set<String> = [
			"waveCircle", "circle", "innerCircle",
			"selectedColor", "deselectedColor",
			"isSelected", "innerIncreaseDelta",
			"useTapGestureRecognizer",
			"didSelect", "didDeselect", "tapGesture.storage" // .storage for lazy vars.
			// Computed properties aren't visible in mirrors.
//			"innerBorderWidth", "innerIncreasedWidth"
		]
		
		let actual = Set(mirror.children.compactMap { $0.label })
		let difference = actual.symmetricDifference(expected)
		
		// ¯\-(ツ)-/¯ Not super-useful, I know.
		XCTAssertTrue(difference.isEmpty, "Properties have changed: \(difference)")
	}
	
	func testOnSelectCallback() {
		var called = false
		radioButton = LTHRadioButton()
		
		radioButton.onSelect {
			called = true
		}
		
		XCTAssertFalse(called)
		
		radioButton.select(animated: false)
		
		XCTAssertTrue(called)
	}
	
	func testOnDeselectCallback() {
		var called = false
		radioButton = LTHRadioButton()
		
		radioButton.onDeselect {
			called = true
		}
		
		radioButton.select(animated: false)
		
		XCTAssertFalse(called)
		
		radioButton.deselect(animated: false)
		
		XCTAssertTrue(called)
	}
	
	func testUseRecognizerTrueAddsRecognizer() {
		radioButton = LTHRadioButton()
		radioButton.useTapGestureRecognizer = true
		
		XCTAssertEqual(1, radioButton.gestureRecognizers?.count)
	}
	
	func testUseRecognizerFalseBeforeCallbacksDoesNotAddRecognizer() {
		radioButton = LTHRadioButton()
		radioButton.useTapGestureRecognizer = false
		
		radioButton.onSelect { }
		
		XCTAssertNil(radioButton.gestureRecognizers)
	}
	
	func testUseRecognizerFalseRemovesRecognizer() {
		radioButton = LTHRadioButton()
		
		radioButton.onSelect { }
		
		radioButton.useTapGestureRecognizer = false
		
		XCTAssertEqual(true, radioButton.gestureRecognizers?.isEmpty)
	}
	
	
	// MARK: - Helpers
	
	private func testState(selected: Bool, file: StaticString = #file, line: UInt = #line) {
		XCTAssertEqual(radioButton.isSelected, selected, file: file, line: line)
		
		mirror.children.forEach {
			switch $0.label {
			case "innerCircle"?:
				guard let innerCircle = $0.value as? UIView else {
					return XCTFail(file: file, line: line)
				}
				
				let expectedWidth: CGFloat = selected ? 6.75 : 0
				XCTAssertEqual(innerCircle.layer.borderWidth, expectedWidth,
				               "Wrong innerCircle border width.", file: file, line: line)
			case "circle"?:
				guard let circle = $0.value as? UIView else {
					return XCTFail(file: file,line: line)
				}
				
				let expectedColor: UIColor = selected ? selectedColor : .lightGray
				XCTAssertEqual(circle.layer.borderColor, expectedColor.cgColor,
				               "Wrong circle border color.", file: file, line: line)
			default: return
			}
		}
	}
	
}
