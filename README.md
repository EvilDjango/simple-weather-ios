# 简易天气 SimpleWeather

> 一个简洁优雅的 iOS 天气应用，使用 SwiftUI 和 WeatherKit 构建

## 📱 功能特性

- ✅ **自动定位**：启动时自动获取当前位置天气
- ✅ **智能搜索**：支持中英文城市名搜索
- ✅ **详细地址**：显示完整的地理位置信息（国家 省份 城市）
- ✅ **实时天气**：显示温度、天气状况、湿度、风速等信息
- ✅ **原生体验**：使用苹果官方 WeatherKit API，数据准确可靠

## 🛠 技术栈

- **语言**：Swift
- **框架**：SwiftUI
- **架构**：MVVM
- **API**：WeatherKit (Apple Official)
- **定位服务**：CoreLocation
- **异步编程**：async/await
- **地理编码**：CLGeocoder

## 📂 项目结构

```
SimpleWeather/
├── Models/              # 数据模型
│   └── WeatherModel.swift
├── ViewModels/          # 视图模型
│   └── WeatherViewModel.swift
├── Views/              # 界面视图
│   └── ContentView.swift
└── Services/           # 业务服务
    ├── WeatherKitService.swift
    └── LocationManager.swift
```

## 🎯 核心功能实现

### 1. 自动定位与反向地理编码

使用 `CoreLocation` 获取用户位置，通过反向地理编码将坐标转换为可读的地址信息：

```swift
// 反向地理编码：坐标 -> 地名
func reverseGeocodeLocation(_ location: CLLocation) async {
    let placemarks = try await geocoder.reverseGeocodeLocation(location)
    // 构建详细地址：中国 四川 成都
    let fullLocationName = [country, province, city].joined(separator: " ")
}
```

### 2. 智能城市搜索

支持中英文城市名输入，通过 `CLGeocoder` 进行地理编码：

```swift
// 地理编码：城市名 -> 坐标 + 详细地址
func geocodeCityWithDetails(_ cityName: String) async throws -> (CLLocation, String)
```

### 3. WeatherKit 集成

使用苹果官方天气服务获取准确的天气数据：

```swift
let weather = try await WeatherService.shared.weather(for: location)
```

## 🚀 快速开始

### 前置要求

- Xcode 15.0+
- iOS 16.0+
- Apple Developer Account（用于 WeatherKit）

### 安装步骤

1. 克隆项目
```bash
git clone https://github.com/yourusername/SimpleWeather.git
```

2. 在 Xcode 中打开项目
```bash
cd SimpleWeather
open SimpleWeather.xcodeproj
```

3. 配置 WeatherKit
   - 在 **Signing & Capabilities** 中添加 **WeatherKit** capability
   - 在开发者网站启用 WeatherKit 服务

4. 配置位置权限
   - 在 **Info.plist** 中添加位置权限描述

5. 运行项目
   - 选择真机设备
   - 按 `Cmd + R` 运行

## 📸 功能演示

### 启动时自动定位
- 打开应用自动获取当前位置天气
- 显示详细地址：中国 四川 成都

### 搜索城市
- 输入中文：`北京`、`上海`、`成都`
- 输入英文：`London`、`Tokyo`、`New York`
- 显示完整地理信息和天气数据

### 天气信息展示
- 🌡️ 温度（摄氏度）
- ☁️ 天气状况
- 💧 湿度百分比
- 💨 风速（m/s）

## 🎨 设计理念

- **简洁优先**：去除冗余功能，专注核心体验
- **原生风格**：遵循 iOS Human Interface Guidelines
- **性能优化**：使用 async/await 实现流畅的异步操作
- **用户友好**：支持中英文输入，自动定位

## 📝 学习要点

这个项目适合学习：

- ✅ SwiftUI 基础组件和布局
- ✅ MVVM 架构模式
- ✅ async/await 异步编程
- ✅ CoreLocation 定位服务
- ✅ WeatherKit API 集成
- ✅ 地理编码与反向地理编码
- ✅ @Published 和 ObservableObject 状态管理

## 🔧 技术亮点

1. **完全使用 SwiftUI**：无 UIKit 代码，现代化的声明式 UI
2. **MVVM 架构**：清晰的代码组织和职责分离
3. **原生 API**：使用 WeatherKit 而非第三方 API，数据更准确
4. **智能地理编码**：中英文城市名自动识别，用户体验友好
5. **错误处理**：完善的错误提示和异常处理

## 🌟 可扩展功能

未来可以添加：

- 📅 7天天气预报
- 🕐 24小时天气趋势
- ⭐️ 收藏城市列表
- 💾 本地缓存
- 🎨 自定义主题
- 🌈 天气动画效果

## 📄 开源协议

MIT License

## 👨‍💻 作者

Django Hunter

## 🙏 致谢

- Apple WeatherKit API
- SwiftUI 社区

---

**开发日期**：2025-11-15
**Swift 版本**：Swift 5.9+
**iOS 版本**：iOS 16.0+
