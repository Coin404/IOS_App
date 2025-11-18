//
//  ContentView.swift
//  CoinApp
//
//  Created by 徐弈 on 2025/11/13.
//

import SwiftUI

struct ContentView: View {
    @State private var showHelloWorld = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                // 背景色
                Color(red: 0.95, green: 0.95, blue: 1.0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showHelloWorld = true
                    }
                
                VStack(spacing: 20) {
                    // 顶部图标和标题区域
                    VStack(spacing: 8) {
                        Spacer()
                            .frame(height: 60)
                        ZStack {
                            Circle()
                                .frame(width: 200, height: 200)
                                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 1.0))
                            
                            Image("app_icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 120, height: 120)
                        }
                        Spacer()
                            .frame(height: 20)
                        Text("树阴照水")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.black)
                        
                        Text("Echo")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                        
                        VStack(spacing: 10) {
                            Text("找到属于自己的声音")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            Text("听见内心的回响")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // 登录按钮区域
                    VStack(spacing: 12) {
                        // Apple登录按钮
                        Button(action: {}) {
                            HStack(spacing: 12) {
                                Image("apple")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                
                                Text("Apple 登录")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 48)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(12)
                            .shadow(color: .black.opacity(0.2), radius: 6, x: 0, y: 3)
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                        .buttonStyle(LoginButtonStyle())
                        
                        // 微信登录按钮
                        Button(action: {}) {
                            HStack(spacing: 12) {
                                Image("wechat")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                
                                Text("微信登录")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 48)
                            .background(Color.green.opacity(0.6))
                            .cornerRadius(12)
                            .shadow(color: .green.opacity(0.2), radius: 6, x: 0, y: 3)
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                        .buttonStyle(LoginButtonStyle())
                        
                        // QQ登录按钮
                        Button(action: {}) {
                            HStack(spacing: 12) {
                                Image("qq")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 22, height: 22)
                                
                                Text("QQ登录")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 48)
                            .background(Color.blue.opacity(0.6))
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.2), radius: 6, x: 0, y: 3)
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                        .buttonStyle(LoginButtonStyle())
                        
                        // 手机号登录按钮
                        Button(action: {}) {
                            HStack(spacing: 12) {
                                Image("phone")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 20, height: 20)
                                
                                Text("手机号登录")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.black)
                            }
                            .frame(maxWidth: .infinity, maxHeight: 48)
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
                            )
                            .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                        .buttonStyle(LoginButtonStyle())
                        
                        Text("选择登录方式")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                    .padding(.bottom, 40)
                }
                .navigationDestination(isPresented: $showHelloWorld) {
                    CoupleSpaceView()
                }
            }
        }
    }
}

// 登录按钮点击反馈样式
struct LoginButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
