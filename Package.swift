// swift-tools-version:5.9
import PackageDescription

let package = Package(
	name: "MacOnAir",
	platforms: [
		.macOS(.v10_15)
	],
	dependencies: [
		.package(url: "https://github.com/sindresorhus/is-camera-on", from: "3.0.0")
	],
	targets: [
		.executableTarget(
			name: "MacOnAir",
			dependencies: [
				.product(name: "IsCameraOn", package: "is-camera-on")
			]
		)
	]
)
