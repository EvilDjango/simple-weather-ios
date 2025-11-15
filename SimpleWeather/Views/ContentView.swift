//
//  ContentView.swift
//  SimpleWeather
//
//  Created by Django on 2025/11/15.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var cityName = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // 搜索框
                HStack {
                    TextField("搜索城市（支持中英文）", text: $cityName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .submitLabel(.search)
                        .onSubmit {
                            Task {
                                await viewModel.searchWeather(for: cityName)
                            }
                        }

                    Button(action: {
                        Task {
                            await viewModel.searchWeather(for: cityName)
                        }
                    }) {
                        Image(systemName: "magnifyingglass")
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(cityName.isEmpty)

                    Button(action: {
                        Task {
                            await viewModel.fetchWeatherForCurrentLocation()
                        }
                    }) {
                        Image(systemName: "location.fill")
                    }
                    .buttonStyle(.bordered)
                }
                .padding()

                // 加载状态
                if viewModel.isLoading {
                    ProgressView("加载中...")
                        .padding()
                }

                // 错误信息
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                // 天气信息
                if let weather = viewModel.weather {
                    WeatherDetailView(weather: weather)
                }

                Spacer()
            }
            .navigationTitle("简易天气")
        }
    }
}

// 天气详情视图
struct WeatherDetailView: View {
    let weather: WeatherDisplay

    var body: some View {
        VStack(spacing: 15) {
            // 城市名称
            Text(weather.cityName)
                .font(.largeTitle)
                .fontWeight(.bold)

            // 温度
            Text(weather.temperature)
                .font(.system(size: 60))
                .fontWeight(.thin)

            // 天气描述
            Text(weather.description)
                .font(.title2)
                .foregroundColor(.secondary)

            Divider()
                .padding(.vertical)

            // 详细信息
            HStack(spacing: 40) {
                VStack {
                    Text("湿度")
                        .foregroundColor(.secondary)
                    Text(weather.humidity)
                        .font(.title3)
                }

                VStack {
                    Text("风速")
                        .foregroundColor(.secondary)
                    Text(weather.windSpeed)
                        .font(.title3)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue.opacity(0.1))
        )
        .padding()
    }
}

// 预览
#Preview {
    ContentView()
}
