// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

/// 网格上下文
public struct GridCellContext<Item> {
    public let item: Item
    public let index: Int
    public let cellWidth: CGFloat
}

/// 响应式网格布局组件
public struct ResponsiveGrid<Item: Identifiable, Content: View>: View {
    private let items: [Item]
    private let config: GridConfiguration
    private let cell: (_ context: GridCellContext<Item>) -> Content
    
    /// 创建响应式网格
    /// - Parameters:
    ///   - items: 要显示的项目数组
    ///   - config: 网格配置
    ///   - content: 内容构建闭包，接收项目和计算出的宽度
    public init(
        items: [Item],
        config: GridConfiguration = GridConfiguration(),
        @ViewBuilder cell: @escaping (_ context: GridCellContext<Item>) -> Content
    ) {
        self.items = items
        self.config = config
        self.cell = cell
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let breakpoint = Breakpoint.current(for: totalWidth)
            let columnCount = config.columns(for: breakpoint)
            
            // 计算项目宽度
            let itemWidth: CGFloat = {
                let totalPadding = config.padding * 2
                let totalColumnSpacing = config.columnSpacing * CGFloat(columnCount - 1)
                let availableWidth = totalWidth - totalPadding - totalColumnSpacing
                let widthPerItem = availableWidth / CGFloat(columnCount)
                return widthPerItem
            }()
            
            let columns = Array(
                repeating: GridItem(.fixed(itemWidth), spacing: config.columnSpacing),
                count: columnCount
            )
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: config.rowSpacing) {
                    ForEach(items.indices, id: \.self) { index in
                        cell(GridCellContext(item: items[index], index: index, cellWidth: itemWidth))
                            .frame(width: itemWidth)
                            .clipped()
                            .contentShape(Rectangle()) // 确保整个区域可点击
                        
                    }
                }
                .padding(config.padding)
            }
        }
    }
}

/// 网格配置结构体
public struct GridConfiguration {
    /// 各断点对应的列数
    public var columnsForBreakpoint: [Breakpoint: Int]
    
    /// 行间距
    public var rowSpacing: CGFloat
    
    /// 列间距
    public var columnSpacing: CGFloat
    
    /// 内容边距
    public var padding: CGFloat
    
    /// 初始化配置
    public init(
        columnsForBreakpoint: [Breakpoint: Int] = [
            .xs: 3,  // 小屏手机显示3列
            .sm: 4,  // 标准手机显示4列
            .md: 5,  // 大屏手机/平板显示5列
            .lg: 6,  // 横屏/大平板显示6列
            .xl: 7,  // 超大屏幕显示7列
            .xxl: 8  // 极限宽度显示8列
        ],
        rowSpacing: CGFloat = 1,
        columnSpacing: CGFloat = 1,
        padding: CGFloat = 0
    ) {
        self.columnsForBreakpoint = columnsForBreakpoint
        self.rowSpacing = rowSpacing
        self.columnSpacing = columnSpacing
        self.padding = padding
    }
    
    /// 获取指定断点的列数
    public func columns(for breakpoint: Breakpoint) -> Int {
        columnsForBreakpoint[breakpoint] ?? 1
    }
}

/// 定义响应式网格布局的断点
public enum Breakpoint: CaseIterable {
    case xs    // < 375 (iPhone SE/小屏设备)
    case sm    // 375 - 413 (标准iPhone)
    case md    // 414 - 767 (iPhone Plus/Max 和小平板)
    case lg    // 768 - 1023 (平板竖屏)
    case xl    // 1024 - 1365 (平板横屏/小桌面)
    case xxl   // 1366+ (大桌面)
    
    /// 断点对应的宽度范围
    public var range: Range<CGFloat> {
        switch self {
        case .xs: return 0..<375
        case .sm: return 375..<414
        case .md: return 414..<768
        case .lg: return 768..<1024
        case .xl: return 1024..<1366
        case .xxl: return 1366..<CGFloat.infinity
        }
    }
    
    /// 根据可用宽度确定当前断点
    public static func current(for width: CGFloat) -> Breakpoint {
        Self.allCases.first { $0.range.contains(width) } ?? .xxl
    }
}
