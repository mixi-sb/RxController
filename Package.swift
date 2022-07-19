// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "RxController",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "RxController", targets: ["RxController"])
    ],
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift.git", .upToNextMajor(from: "6.0.0")),
        .package(url: "https://github.com/RxSwiftCommunity/RxFlow.git", .upToNextMajor(from: "2.12.0"))
    ],
    targets: [
        .target(name: "RxController",
                dependencies: [
                    "RxSwift",
                    .product(name: "RxCocoa", package: "RxSwift"),
                    "RxFlow"
                ]
               )
    ],
    swiftLanguageVersions: [.v5]
)
