//
//  HelloWorldView.swift
//  CoinApp
//
//  Created by 徐弈 on 2025/11/13.
//

import SwiftUI

struct HelloWorldView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack {
                Text("Hello World")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.black)
            }
        }
    }
}

struct HelloWorldView_Previews: PreviewProvider {
    static var previews: some View {
        HelloWorldView()
    }
}