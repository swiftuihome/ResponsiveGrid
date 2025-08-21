# ResponsiveGrid

一个轻量级、高性能的 SwiftUI 响应式网格布局组件。它能够根据容器的宽度自动选择最佳的列数，让你的界面在从 iPhone 到 iPad 乃至 Mac 的所有 Apple 设备上都拥有完美的视觉表现。

[![SwiftUI](https://img.shields.io/badge/SwiftUI-5+-orange.svg?style=flat&logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![Platforms](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20tvOS%20%7C%20watchOS-lightgrey.svg)](https://developer.apple.com/)
[![SPM](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://swift.org/package-manager/)

## 特性

-   **🚀 开箱即用**：默认配置即可获得良好的响应式效果。
-   **🎛️ 高度可定制**：完全控制不同断点下的列数、间距和边距。
-   **📱 全平台支持**：支持 iOS, macOS, tvOS 和 watchOS。
-   **🧩 简单 API**：类似 SwiftUI 原生 `LazyVGrid` 的声明式语法，学习成本低。
-   **🔍 自动断点**：内置基于Bootstrap标准的断点系统（xs, sm, md, lg, xl, xxl），也可轻松自定义。
-   **📐 精确尺寸**：为每个单元格提供计算好的精确宽度，轻松实现等宽高或其他布局。

## 安装

### Swift Package Manager

1.  在 Xcode 中，选择 `File > Add Package Dependencies...`
2.  输入仓库地址：`https://github.com/swiftuihome/ResponsiveGrid.git`
3.  选择版本规则，并添加到你的项目靶标中。

或者，将以下依赖添加到你的 `Package.swift` 文件中：

```swift
dependencies: [
    .package(url: "https://github.com/swiftuihome/ResponsiveGrid.git", from: "1.0.0")
]
```

## 快速开始

```swift
import SwiftUI
import ResponsiveGrid

// 1. 定义你的数据模型（需遵循 Identifiable 协议）
struct PhotoItem: Identifiable {
    let id = UUID()
    let color: Color
}

struct ContentView: View {
    // 2. 准备数据
    let items = (0..<50).map { _ in PhotoItem(color: .random) }
    
    var body: some View {
        // 3. 使用 ResponsiveGrid
        ResponsiveGrid(items: items) { context in
            // 4. 定义每个单元格的视图
            RoundedRectangle(cornerRadius: 10)
                .fill(context.item.color)
                .frame(height: context.cellWidth) // 利用提供的宽度实现正方形
                .overlay(Text("\(context.index)"))
        }
    }
}
```

## 高级用法

### 自定义网格配置

你可以通过传递一个 `GridConfiguration` 实例来完全自定义网格的行为。

```swift
let customConfig = GridConfiguration(
    columnsForBreakpoint: [
        .xs: 2,   // 超小屏幕：2列
        .sm: 3,   // 小屏幕：3列
        .md: 4,   // 中屏幕：4列
        .lg: 5,   // 大屏幕：5列
        .xl: 6,   // 超大屏幕：6列
        .xxl: 8   // 极大屏幕：8列
    ],
    rowSpacing: 8,
    columnSpacing: 8,
    padding: 16
)

ResponsiveGrid(items: items, config: customConfig) { context in
    // 你的单元格视图
}
```

### 访问上下文信息

每个单元格的构建闭包提供一个 `GridCellContext` 对象，包含：
-   `item: Item`：当前的数据项。
-   `index: Int`：当前项的索引。
-   `cellWidth: CGFloat`：计算出的单元格宽度，对于实现等高或其他动态布局非常有用。

## API 概览

### ResponsiveGrid
主视图组件。
-   `init(items: [Item], config: GridConfiguration, cell: @escaping (GridCellContext<Item>) -> Content)`

### GridConfiguration
配置网格布局的结构体。
-   `columnsForBreakpoint: [Breakpoint: Int]`：定义各断点对应的列数。
-   `rowSpacing: CGFloat`：行间距。
-   `columnSpacing: CGFloat`：列间距。
-   `padding: CGFloat`：内边距。

### Breakpoint
响应式断点枚举：`.xs`, `.sm`, `.md`, `.lg`, `.xl`, `.xxl`。
-   `static func current(for width: CGFloat) -> Breakpoint`：根据宽度获取当前断点。

## 示例

项目中包含两个演示示例：
1.  `ResponsiveGridDemo`：使用默认配置的演示。
2.  `ResponsiveGridCustomConfigDemo`：使用自定义配置的演示。

运行项目并旋转设备或调整窗口大小，即可看到网格布局如何平滑地响应尺寸变化。

## 要求

-   iOS 15+ / macOS 13+ / tvOS 15+ / watchOS 8+
-   Swift 5.9+
-   Xcode 15+
