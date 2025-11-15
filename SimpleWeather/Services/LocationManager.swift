import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    @Published var location: CLLocation?
    @Published var locationName: String?  // 当前位置的名称
    @Published var authorizationStatus: CLAuthorizationStatus?
    @Published var errorMessage: String?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    // 请求位置权限
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    // 获取当前位置
    func requestLocation() {
        locationManager.requestLocation()
    }

    // 反向地理编码：坐标 -> 地名
    func reverseGeocodeLocation(_ location: CLLocation) async {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first else { return }

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

            DispatchQueue.main.async {
                self.locationName = fullLocationName
                print("📍 当前位置名称: \(fullLocationName)")
            }
        } catch {
            print("❌ 反向地理编码失败: \(error)")
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("📍 位置权限已授予")
        case .denied, .restricted:
            errorMessage = "需要位置权限才能获取当前位置的天气"
        case .notDetermined:
            print("📍 位置权限未确定")
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        print("📍 获取到位置: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "获取位置失败：\(error.localizedDescription)"
        print("❌ 位置错误: \(error)")
    }
}
