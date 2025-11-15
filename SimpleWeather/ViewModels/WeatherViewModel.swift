import Foundation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    // 发布的属性（变化时自动更新UI）
    @Published var weather: WeatherDisplay?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let weatherService = WeatherService()

    // 搜索天气
    func searchWeather(for city: String) async {
        // 清空之前的数据
        errorMessage = nil
        isLoading = true

        // 转换城市名（中文 -> 英文）
        let convertedCity = CityMapper.convert(cityName: city)
        print("🏙️ 输入城市: \(city) -> 转换后: \(convertedCity)")

        do {
            // 调用网络服务
            let response = try await weatherService.fetchWeather(for: convertedCity)
            // 转换为显示模型
            weather = WeatherDisplay(from: response)
        } catch NetworkError.cityNotFound {
            errorMessage = "城市未找到，请检查城市名称拼写是否正确"
            weather = nil
        } catch NetworkError.apiError(let message) {
            errorMessage = "API错误：\(message)"
            weather = nil
        } catch {
            errorMessage = "获取天气失败：\(error.localizedDescription)"
            weather = nil
        }

        isLoading = false
    }
}
