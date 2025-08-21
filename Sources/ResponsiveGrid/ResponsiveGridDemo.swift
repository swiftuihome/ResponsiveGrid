//
//  ResponsiveGridDemo.swift
//  ResponsiveGrid
//
//  Created by devlink on 2025/8/21.
//

import SwiftUI

// 数据模型
public struct PhotoItem: Identifiable {
    public let id = UUID()
    public let imageName: String
    public let backgroundColor: Color
}

public struct ResponsiveGridDemo: View {
    // 模拟照片
    let photos: [PhotoItem] = (0..<120).map { index in .init(imageName: "\(index)", backgroundColor: Color.random) }
    
    public init() {}
    
    public var body: some View {
        ResponsiveGrid(items: photos) { context in
            context.item.backgroundColor
                .frame(height: context.cellWidth)
                .overlay {
                    Text("\(context.index)")
                }
                .onTapGesture {
                    print("点击了\(context.index)")
                }
        }
    }
}

public struct ResponsiveGridCustomConfigDemo: View {
    // 模拟照片
    let photos: [PhotoItem] = (0..<120).map { index in .init(imageName: "\(index)", backgroundColor: Color.random) }
    
    // 自定义配置
    let config: GridConfiguration = .init(
        columnsForBreakpoint: [
            .xs: 1,
            .sm: 2,
            .md: 3,
            .lg: 4,
            .xl: 5,
            .xxl: 6
        ],
        rowSpacing: 1,
        columnSpacing: 1,
        padding: 0
    )
    
    public init() {}
    
    public var body: some View {
        ResponsiveGrid(items: photos, config: config) { context in
            context.item.backgroundColor
                .frame(height: context.cellWidth)
                .overlay {
                    Text("\(context.index)")
                }
                .onTapGesture {
                    print("点击了\(context.index)")
                }
        }
    }
}

#Preview("ResponsiveGridDemo") {
    ResponsiveGridDemo()
        .preferredColorScheme(.dark)
}

#Preview("ResponsiveGridCustomConfigDemo") {
    ResponsiveGridCustomConfigDemo()
        .preferredColorScheme(.dark)
}

public extension Color {
    /// 生成随机颜色
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
