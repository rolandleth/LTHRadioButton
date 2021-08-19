// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "LTHRadioButton",
  products: [
    .library(
		name: "LTHRadioButton",
		targets: ["LTHRadioButton"]
	),
  ],
  targets: [
    .target(
		name: "LTHRadioButton",
		dependencies: [],
		path: "source"
	),
  ]
)
