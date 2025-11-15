import Foundation
import WeatherKit

// 用于展示的天气模型
struct WeatherDisplay {
    let cityName: String
    let temperature: String
    let description: String
    let humidity: String
    let windSpeed: String

    // 从 WeatherKit 的 Weather 对象转换为展示模型
    init(from weather: WeatherKit.Weather, cityName: String) {
        self.cityName = cityName
        self.temperature = "\(Int(weather.currentWeather.temperature.value))°C"
        self.description = weather.currentWeather.condition.description
        self.humidity = "\(Int(weather.currentWeather.humidity * 100))%"
        self.windSpeed = String(format: "%.1f m/s", weather.currentWeather.wind.speed.value)
    }
}
