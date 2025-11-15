import Foundation

// 天气响应数据（对应API返回的JSON结构）
struct WeatherResponse: Codable {
    let main: MainWeather
    let weather: [Weather]
    let wind: Wind
    let name: String  // 城市名称
}

// 主要天气数据（温度、湿度等）
struct MainWeather: Codable {
    let temp: Double      // 温度
    let humidity: Int     // 湿度
    let pressure: Int     // 气压
}

// 天气描述
struct Weather: Codable {
    let main: String        // 主要天气（如：Clear）
    let description: String // 详细描述（如：晴天）
    let icon: String        // 图标代码
}

// 风速数据
struct Wind: Codable {
    let speed: Double  // 风速
}

// 用于展示的天气模型（简化版）
struct WeatherDisplay {
    let cityName: String
    let temperature: String
    let description: String
    let humidity: String
    let windSpeed: String
    let icon: String

    // 从API响应转换为展示模型
    init(from response: WeatherResponse) {
        self.cityName = response.name
        self.temperature = "\(Int(response.main.temp))°C"
        self.description = response.weather.first?.description ?? "未知"
        self.humidity = "\(response.main.humidity)%"
        self.windSpeed = "\(response.wind.speed) m/s"
        self.icon = response.weather.first?.icon ?? ""
    }
}
