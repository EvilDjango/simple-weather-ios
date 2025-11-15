import Foundation

// 网络请求错误类型
enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case cityNotFound
    case apiError(String)
}

// API错误响应
struct ErrorResponse: Codable {
    let cod: String
    let message: String
}

class WeatherService {
    private let apiKey = "fee4402c8d823c07009ef3d77fa439fd"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    // 获取天气数据（异步函数）
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        // 1. 构建URL
        var components = URLComponents(string: baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),  // 摄氏度
            URLQueryItem(name: "lang", value: "zh_cn")     // 中文
        ]

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        print("🌐 请求URL: \(url)")

        // 2. 发起网络请求
        let (data, response) = try await URLSession.shared.data(from: url)

        // 打印响应状态
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 HTTP状态码: \(httpResponse.statusCode)")
        }

        // 打印原始JSON数据
        if let jsonString = String(data: data, encoding: .utf8) {
            print("📄 API返回数据: \(jsonString)")
        }

        // 3. 先检查是否是错误响应
        let decoder = JSONDecoder()

        // 尝试解析错误响应
        if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
            if errorResponse.cod == "404" {
                throw NetworkError.cityNotFound
            } else {
                throw NetworkError.apiError(errorResponse.message)
            }
        }

        // 4. 解析正常的天气数据
        do {
            let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
            return weatherResponse
        } catch {
            print("❌ 解析错误: \(error)")
            throw NetworkError.decodingError
        }
    }
}
