//
//  MoodDiaryCalendarView.swift
//  CoinApp
//
//  Created by 徐弈 on 2025/11/13.
//

import SwiftUI
import Combine

// API响应数据模型
struct CurrentDateResponse: Codable {
    let code: Int
    let msg: String
    let data: CurrentDateInfo
}

struct CurrentDateInfo: Codable {
    let daysInMonth: Int
    let month: Int
    let year: Int
    let day: Int
}

struct MoodDiaryCalendarView: View {
    // 环境变量
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    // 状态变量
    @State private var currentDateInfo: CurrentDateInfo?
    @State private var isLoading = false
    
    // 主视图
    var body: some View {
        // 根容器
        VStack() {
            // 顶部栏
            self.createTopBar()
            
            // 空内容
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
        .padding(.top, 30)
        .padding(.bottom, 10)
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
        .padding(.bottom, 20)
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
        .padding(.bottom, 20)
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
            let (data, _response) = try await URLSession.shared.data(for: request)
            
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
