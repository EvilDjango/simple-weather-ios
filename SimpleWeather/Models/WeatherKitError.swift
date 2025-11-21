import Foundation

// App 中关于 WeatherKit 服务可能发生的特定错误
enum WeatherKitError: Error {
    /// 未能通过地理编码找到指定的城市
    case cityNotFound
    
    /// 无法获取用户当前的位置
    case locationUnavailable
}
