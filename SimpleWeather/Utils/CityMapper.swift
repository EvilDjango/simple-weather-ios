import Foundation

class CityMapper {
    // 中文城市名到英文的映射表
    private static let cityMap: [String: String] = [
        // 直辖市
        "北京": "Beijing",
        "上海": "Shanghai",
        "天津": "Tianjin",
        "重庆": "Chongqing",

        // 省会城市
        "广州": "Guangzhou",
        "深圳": "Shenzhen",
        "成都": "Chengdu",
        "杭州": "Hangzhou",
        "武汉": "Wuhan",
        "西安": "Xi'an",
        "南京": "Nanjing",
        "郑州": "Zhengzhou",
        "济南": "Jinan",
        "长沙": "Changsha",
        "哈尔滨": "Harbin",
        "沈阳": "Shenyang",
        "石家庄": "Shijiazhuang",
        "太原": "Taiyuan",
        "呼和浩特": "Hohhot",
        "长春": "Changchun",
        "南昌": "Nanchang",
        "福州": "Fuzhou",
        "合肥": "Hefei",
        "昆明": "Kunming",
        "贵阳": "Guiyang",
        "南宁": "Nanning",
        "拉萨": "Lhasa",
        "兰州": "Lanzhou",
        "西宁": "Xining",
        "银川": "Yinchuan",
        "乌鲁木齐": "Urumqi",
        "海口": "Haikou",

        // 其他重要城市
        "苏州": "Suzhou",
        "大连": "Dalian",
        "青岛": "Qingdao",
        "宁波": "Ningbo",
        "厦门": "Xiamen",
        "无锡": "Wuxi",
        "佛山": "Foshan",
        "东莞": "Dongguan",
        "泉州": "Quanzhou",
        "温州": "Wenzhou",
        "珠海": "Zhuhai",
        "中山": "Zhongshan",
        "烟台": "Yantai",
        "南通": "Nantong",
        "嘉兴": "Jiaxing",
        "绍兴": "Shaoxing",
        "惠州": "Huizhou",
        "常州": "Changzhou",
        "徐州": "Xuzhou",
        "潍坊": "Weifang",
        "保定": "Baoding",
        "洛阳": "Luoyang",
        "威海": "Weihai",
        "扬州": "Yangzhou",
        "桂林": "Guilin",
        "汕头": "Shantou",
        "三亚": "Sanya",

        // 国际城市（常见）
        "伦敦": "London",
        "巴黎": "Paris",
        "纽约": "New York",
        "东京": "Tokyo",
        "首尔": "Seoul",
        "新加坡": "Singapore",
        "悉尼": "Sydney",
        "莫斯科": "Moscow",
        "柏林": "Berlin",
        "罗马": "Rome",
        "马德里": "Madrid",
        "洛杉矶": "Los Angeles",
        "旧金山": "San Francisco",
        "芝加哥": "Chicago",
        "多伦多": "Toronto",
        "温哥华": "Vancouver",
        "曼谷": "Bangkok",
        "迪拜": "Dubai",
        "香港": "Hong Kong",
        "澳门": "Macau",
        "台北": "Taipei"
    ]

    // 转换城市名称（中文 -> 英文）
    static func convert(cityName: String) -> String {
        // 去除首尾空格
        let trimmedCity = cityName.trimmingCharacters(in: .whitespacesAndNewlines)

        // 如果在映射表中找到，返回英文名
        if let englishName = cityMap[trimmedCity] {
            return englishName
        }

        // 如果没找到，返回原始输入（可能已经是英文）
        return trimmedCity
    }

    // 检查是否是支持的中文城市名
    static func isChineseCity(_ cityName: String) -> Bool {
        let trimmedCity = cityName.trimmingCharacters(in: .whitespacesAndNewlines)
        return cityMap.keys.contains(trimmedCity)
    }

    // 获取所有支持的中文城市列表
    static func getAllChineseCities() -> [String] {
        return Array(cityMap.keys).sorted()
    }
}
