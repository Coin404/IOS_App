import SwiftUI
import Combine

// API响应数据模型
struct CurrentDateResponse: Codable {
    let code: Int
    let msg: String
    let data: CurrentDateInfo
}

// API响应数据模型
struct CurrentDateInfo: Codable {
    let daysInMonth: Int
    let month: Int
    let year: Int
    let day: Int
}

// 心情数据结构
struct MoodData: Identifiable {
    let id = UUID()
    let date: Date
    let mood: MoodState
}

// 心情状态枚举
enum MoodState: CaseIterable {
    case happy
    case sad
    case angry
    case neutral
    case none
}

// MoodState 扩展，封装图标和颜色信息
extension MoodState {
    var symbolName: String {
        switch self {
        case .happy:
            return "face.smiling.fill"
        case .sad:
            return "face.sad.fill"
        case .angry:
            return "face.angry.fill"
        case .neutral:
            return "face.neutral.fill"
        case .none:
            return "circle.outline"
        }
    }
    
    var color: Color {
        switch self {
        case .happy:
            return .yellow
        case .sad:
            return .blue
        case .angry:
            return .red
        case .neutral:
            return .gray
        case .none:
            return .gray
        }
    }
}

struct MoodDiaryCalendarView: View {
    // 环境变量
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    // 状态变量
    @State private var currentDateInfo: CurrentDateInfo?
    @State private var isLoading = false
    @State private var moodData: [MoodData] = []
    
    // 计算属性：生成当月所有日期
    private var currentMonthDates: [Date] {
        guard let dateInfo = currentDateInfo else { return [] }
        
        let calendar = Calendar.current
        // 生成当月所有日期
        var dates: [Date] = []
        for day in 1...dateInfo.daysInMonth {
            guard let date = calendar.date(from: DateComponents(year: dateInfo.year, month: dateInfo.month, day: day)) else { continue }
            dates.append(date)
        }
        
        return dates
    }
    
    // 获取星期几，1=周一，7=周日
    private func getDayOfWeek(_ date: Date) -> Int {
        let calendar = Calendar.current
        let dayOfWeek = calendar.component(.weekday, from: date)
        
        // 将周日从1转换为7
        return dayOfWeek == 1 ? 7 : dayOfWeek - 1
    }
    
    // 主视图
    var body: some View {
        // 根容器
        VStack() {
            // 顶部栏 - 从顶部开始
            self.createTopBar()
            
            // 日历内容 - 居中显示
            VStack() {
                if isLoading {
                    // 加载状态
                    Text("Loading...")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.gray)
                } else if currentDateInfo != nil {
                    // 星期标题
                    HStack(spacing: 0) {
                        Text("一")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                        Text("二")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                        Text("三")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                        Text("四")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                        Text("五")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                        Text("六")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                        Text("日")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)
                    
                    // 日历网格
                    let dates = currentMonthDates
                    let firstDayOfWeek = getDayOfWeek(dates.first ?? Date())
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 16) {
                        // 填充月初空白
                        ForEach(0..<(firstDayOfWeek - 1), id: \.self) { _ in
                            Text("")
                        }
                        
                        // 显示日期
                        ForEach(dates, id: \.self) { date in
                            let day = Calendar.current.component(.day, from: date)
                            let isToday = Calendar.current.isDateInToday(date)
                            
                            VStack() {
                                // 日期数字
                                Text("\(day)")
                                    .font(.system(size: 20))
                                    .foregroundColor(isToday ? .orange : .gray)
                                    .fontWeight(isToday ? .bold : .regular)
                                
                                // 心情图标
                                if isToday {
                                    // 当天显示小太阳图标在小圆圈内
                                    ZStack {
                                        // 空心圆圈背景（黑色线条）
                                        Image(systemName: "circle")
                                            .foregroundColor(.gray.opacity(0.5)) 
                                            .font(.system(size: 40, weight: .ultraLight))
                                           // 小太阳图标
                                        Image(systemName: "sun.min.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 30))
                                    }
                                    .frame(width: 40, height: 40)
                                } else {
                                    ZStack {
                                        Image(systemName: "circle")
                                            .foregroundColor(.gray.opacity(0.5))
                                            .font(.system(size: 40, weight: .ultraLight))
                               
                                    }
                                    .frame(width: 40, height: 40)
                                }
                            }
                            .frame(height: 80)
                        }
                    }
                    .padding(.horizontal, 20)
                } else {
                    // 初始状态
                    Text("获取日期信息失败")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.top, 30)
            
            // 空白区域 - 保持日历内容居中
            Spacer()
        }
        .background(Color.white)
        .onAppear {
            // 页面加载时获取日期信息
            Task {
                await fetchCurrentDateInfo()
            }
        }
    }
    
    // 创建顶部栏
    private func createTopBar() -> some View {
        HStack() {
            // 返回按钮
            self.createBackButton()
            
            Spacer()
            
            // 日期标题
            if isLoading {
                // 加载状态
                self.createLoadingTitle()
            } else if let date = currentDateInfo {
                // 加载成功
                self.createDateTitle(date: date)
            } else {
                // 初始状态
                Text("获取日期信息失败")
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
    }
    
    // 返回按钮
    private func createBackButton() -> some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 24))
                .foregroundColor(Color.gray)
        }
    }
    
    // 加载状态的日期标题
    private func createLoadingTitle() -> some View {
        VStack() {
            Text("Loading...")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color.black)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 5)
    }
    
    // 真实数据的日期标题
    private func createDateTitle(date: CurrentDateInfo) -> some View {
        // 月份显示为"11月"格式
        let monthText = "\(date.month)月"
        
        // 年份格式化，去除逗号分隔
        let yearFormatter = NumberFormatter()
        yearFormatter.groupingSeparator = ""
        yearFormatter.numberStyle = .decimal
        let yearText = yearFormatter.string(from: NSNumber(value: date.year)) ?? "\(date.year)"
        
        return VStack() {
            // 月份
            Text(monthText)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(Color.black.opacity(0.8))
            
            // 年份
            Text("\(yearText)年")
                .font(.system(size: 12))
                .foregroundColor(Color.gray.opacity(0.6))
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 5)
    }
    
    // 从API获取当前日期信息
    private func fetchCurrentDateInfo() async {
        guard let url = URL(string: "http://localhost:9000/coin_java/common/currentDateInfo.public") else {
            print("Invalid URL")
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            // 创建POST请求
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // 发送POST请求
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 解析响应
            let dateResponse = try JSONDecoder().decode(CurrentDateResponse.self, from: data)
            if dateResponse.code == 0 {
                currentDateInfo = dateResponse.data
            } else {
                print("Failed to get date info: \(dateResponse.msg)")
            }
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
        } catch let error {
            print("Failed to fetch date info: \(error)")
        }
    }
}

struct MoodDiaryCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        MoodDiaryCalendarView()
    }
}
