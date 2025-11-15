import Foundation
import WeatherKit
import CoreLocation

class WeatherKitService {
    private let service = WeatherKit.WeatherService.shared

    // 获取指定位置的天气
    func fetchWeather(for location: CLLocation) async throws -> WeatherKit.Weather {
        do {
            let weather = try await service.weather(for: location)
            print("✅ 成功获取天气数据")
            return weather
        } catch let error as NSError {
            print("❌ WeatherKit 错误详情:")
            print("   Domain: \(error.domain)")
            print("   Code: \(error.code)")
            print("   Description: \(error.localizedDescription)")
            print("   UserInfo: \(error.userInfo)")
            throw error
        }
    }

    // 根据城市名获取天气（需要先转换成坐标）
    func fetchWeather(for cityName: String) async throws -> WeatherKit.Weather {
        // 使用地理编码将城市名转换为坐标
        let location = try await geocodeCity(cityName)
        return try await fetchWeather(for: location)
    }

    // 地理编码：城市名 -> 坐标 + 详细地址（支持中文！）
    func geocodeCityWithDetails(_ cityName: String) async throws -> (location: CLLocation, fullName: String) {
        let geocoder = CLGeocoder()

        print("🗺️ 正在将城市名转换为坐标: \(cityName)")

        let placemarks = try await geocoder.geocodeAddressString(cityName)

        guard let placemark = placemarks.first,
              let location = placemark.location else {
            throw WeatherKitError.cityNotFound
        }

        // 构建详细地址：中国 四川 成都
        var components: [String] = []

        if let country = placemark.country {
            components.append(country)
        }
        if let administrativeArea = placemark.administrativeArea {  // 省/州
            components.append(administrativeArea)
        }
        if let locality = placemark.locality {  // 城市
            components.append(locality)
        }

        let fullLocationName = components.joined(separator: " ")
        print("📍 找到位置: \(fullLocationName)")

        return (location, fullLocationName)
    }

    // 地理编码：城市名 -> 坐标（保留旧方法兼容性）
    private func geocodeCity(_ cityName: String) async throws -> CLLocation {
        let (location, _) = try await geocodeCityWithDetails(cityName)
        return location
    }
}

// 错误类型
enum WeatherKitError: Error {
    case cityNotFound
    case locationUnavailable
}
