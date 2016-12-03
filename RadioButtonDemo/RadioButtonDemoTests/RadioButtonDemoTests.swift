//
//  RadioButtonDemoTests.swift
//  RadioButtonDemoTests
//
//  Created by Roland Leth on 03.12.2016.
//  Copyright © 2016 Roland Leth. All rights reserved.
//

import XCTest

class RadioButtonDemoTests: XCTestCase {
	
	private let selectedColor = UIColor(red: 0.29, green: 0.56, blue: 0.88, alpha: 1.0)
	private lazy var mirror: Mirror = Mirror(reflecting: self.radioButton)
	private var radioButton: LTHRadioButton!
	
	
	// MARK: -
	
	func testDefaultValues() {
		radioButton = LTHRadioButton()
		
		XCTAssertNotNil(radioButton)
		XCTAssertEqual(radioButton.selectedColor, selectedColor)
		XCTAssertEqual(radioButton.deselectedColor, .lightGray)
		XCTAssertEqual(radioButton.frame, CGRect(x: 0, y: 0, width: 18, height: 18))
	}
	
	func testPassedParameters() {
		let selectedColor = UIColor.red
		let deselectedColor = UIColor.blue
		let frame = CGRect(origin: .zero, size: CGSize(width: 20, height: 20))
		
		radioButton = LTHRadioButton(radius: frame.size.width,
		                             selectedColor: selectedColor,
		                             deselectedColor: deselectedColor)
		
		XCTAssertNotNil(radioButton)
		XCTAssertEqual(radioButton.selectedColor, selectedColor)
		XCTAssertEqual(radioButton.deselectedColor, deselectedColor)
		XCTAssertEqual(radioButton.frame, frame)
	}
	
	func testCircles() {
		radioButton = LTHRadioButton()
		let innerSize = CGSize(width: 11.25, height: 11.25) // 18 * 0.6
		let innerCornerRadius: CGFloat = 5.625 // 11.25 * 0.5
		
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
				XCTAssertEqual(circle.layer.cornerRadius, 9)
				XCTAssertEqual(circle.layer.backgroundColor, UIColor.clear.cgColor)
				XCTAssertEqual(circle.layer.borderColor, UIColor.lightGray.cgColor)
				XCTAssertEqual(circle.layer.borderWidth, 1.8)
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
			"isSelected", "innerIncreaseDelta"
			// Computed properties aren't visible in mirrors.
//			"innerBorderWidth", "innerIncreasedWidth"
		]
		
		let actual = Set(mirror.children.flatMap { $0.label })
		let difference = actual.symmetricDifference(expected)
		
		// ¯\-(ツ)-/¯ Not super-useful, I know.
		XCTAssertTrue(difference.isEmpty, "Properties have changed!")
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
