import Foundation
import Combine
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    // 发布的属性（变化时自动更新UI）
    @Published var weather: WeatherDisplay?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let weatherKitService = WeatherKitService()
    let locationManager = LocationManager()

    // 初始化时自动获取当前位置天气
    init() {
        Task {
            await fetchWeatherForCurrentLocation()
        }
    }

    // 搜索城市天气（支持中文！）
    func searchWeather(for city: String) async {
        errorMessage = nil
        isLoading = true

        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCity.isEmpty else {
            isLoading = false
            return
        }

        print("🏙️ 搜索城市: \(trimmedCity)")

        do {
            // 获取详细地址信息
            let (location, fullName) = try await weatherKitService.geocodeCityWithDetails(trimmedCity)
            let weatherData = try await weatherKitService.fetchWeather(for: location)

            // 使用详细地址名称
            weather = WeatherDisplay(from: weatherData, cityName: fullName)
        } catch WeatherKitError.cityNotFound {
            errorMessage = "城市未找到，请检查城市名称"
            weather = nil
        } catch {
            errorMessage = "获取天气失败：\(error.localizedDescription)"
            weather = nil
        }

        isLoading = false
    }

    // 使用当前位置获取天气
    func fetchWeatherForCurrentLocation() async {
        errorMessage = nil
        isLoading = true

        // 请求位置权限
        locationManager.requestPermission()

        // 请求当前位置
        locationManager.requestLocation()

        // 等待位置更新
        for _ in 0..<30 {  // 最多等待3秒
            if let location = locationManager.location {
                do {
                    print("📍 使用位置获取天气: \(location)")

                    // 反向地理编码获取地名
                    await locationManager.reverseGeocodeLocation(location)

                    let weatherData = try await weatherKitService.fetchWeather(for: location)

                    // 使用真实的位置名称，如果获取失败则显示"当前位置"
                    let displayName = locationManager.locationName ?? "当前位置"
                    weather = WeatherDisplay(from: weatherData, cityName: displayName)
                } catch {
                    errorMessage = "获取天气失败：\(error.localizedDescription)"
                }
                isLoading = false
                return
            }

            try? await Task.sleep(nanoseconds: 100_000_000)  // 等待0.1秒
        }

        // 超时或没有权限
        errorMessage = locationManager.errorMessage ?? "无法获取位置，请允许位置权限"
        isLoading = false
    }
}
