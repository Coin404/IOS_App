//
//  CoupleSpaceView.swift
//  CoinApp
//
//  Created by 徐弈 on 2025/11/13.
//

import SwiftUI

struct CoupleSpaceView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top background image with gradient
                ZStack {
                    Image("miemie")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 250)
                        .clipped()
                    
                    // Gradient overlay
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(0.8),
                            Color.clear,
                            Color.white.opacity(0.5)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 250)
                }
                .frame(height: 250)
                
                // Couple Space Title
                VStack(alignment: .leading, spacing: 20) {
                    HStack(spacing: 8) {
                        Image("love")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        
                        Text("情侣空间")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(.darkGray))
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    // Four circular buttons grid
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 30) {
                        // Mood Diary
                        VStack(spacing: 8) {
                            ZStack {
                                HandDrawnCircle()
                                    .stroke(Color(.darkGray), lineWidth: 3)
                                    .frame(width: 60, height: 60)
                                
                                Image("love_book")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color(.darkGray))
                            }
                            
                            Text("心情日记")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.darkGray))
                        }
                        
                        // Love Album
                        VStack(spacing: 8) {
                            ZStack {
                                HandDrawnCircle()
                                    .stroke(Color(.darkGray), lineWidth: 3)
                                    .frame(width: 60, height: 60)
                                
                                Image("camera")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color(.darkGray))
                            }
                            
                            Text("恋爱相册")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.darkGray))
                        }
                        
                        // Anniversary
                        VStack(spacing: 8) {
                            ZStack {
                                HandDrawnCircle()
                                    .stroke(Color(.darkGray), lineWidth: 3)
                                    .frame(width: 60, height: 60)
                                
                                Image("calendar")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color(.darkGray))
                            }
                            
                            Text("纪念日")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.darkGray))
                        }
                        
                        // Memories
                        VStack(spacing: 8) {
                            ZStack {
                                HandDrawnCircle()
                                    .stroke(Color(.darkGray), lineWidth: 3)
                                    .frame(width: 60, height: 60)
                                
                                Image("fire")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(Color(.darkGray))
                            }
                            
                            Text("回忆")
                                .font(.system(size: 14))
                                .foregroundColor(Color(.darkGray))
                        }
                    }
                    .padding(.horizontal, 5)
                    
                    // Activity Records Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("活动记录")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(Color(.darkGray))
                        
                        // Placeholder for future activity records
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 100)
                            .overlay(
                                Text("后续补充")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 40)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

struct CoupleSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        CoupleSpaceView()
    }
}

// Hand-drawn style circle shape with very subtle wobble effect
struct HandDrawnCircle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        
        // Very subtle wobble - more segments for smoother circle
        let segments = 30
        let angleStep = (2 * CGFloat.pi) / CGFloat(segments)
        
        for i in 0..<segments {
            let angle = CGFloat(i) * angleStep
            
            // Minimal randomness - just slight imperfections
            let radiusVariation = CGFloat.random(in: -0.8...0.8)
            let currentRadius = radius + radiusVariation
            
            let point = CGPoint(
                x: center.x + currentRadius * cos(angle),
                y: center.y + currentRadius * sin(angle)
            )
            
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        
        path.closeSubpath()
        return path
    }
}
