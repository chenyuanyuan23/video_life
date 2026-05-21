// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "video_life",
    platforms: [
        .iOS("12.0")
    ],
    products: [
        .library(name: "video-life", targets: ["video_life"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "video_life",
            dependencies: [],
            resources: [
                .copy("Resources/silent.mp3")
            ]
        )
    ]
)
