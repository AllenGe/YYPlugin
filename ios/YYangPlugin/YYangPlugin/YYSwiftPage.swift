//
//  YYSwiftPage.swift
//  YYangPlugin
//
//  Created by mt on 2025/4/1.
//

import SwiftUI
import UIKit

// 定义一个公开的 SwiftUI 视图结构体，用于展示页面内容
@available(iOS 15.0, *)
public struct YYSwiftPage: View {
    @Environment(\.dismiss) private var dismiss
    
    public let message: String
    let screenWidth = UIScreen.main.bounds.width

    public var body: some View {
        
        VStack(alignment: .leading) {
            
            Text(message)
                .font(.title)
            HStack {
                Text("Joshua Tree National Park")
                Spacer()
                Text("California")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Divider()

            Text("About Turtle Rock")
                .font(.title2)
            Text("Descriptive text goes here.")
            
            Spacer()
            
            
            HStack() {
                Spacer();Text("© YY").font(.subheadline);Spacer()
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
//            .background(Color(cgColor: Tools.cgColor("#666666")))
//            .frame(height:20)


        }
        .padding(EdgeInsets(top: 12, leading: 12, bottom: 0, trailing: 12))
        .background(Color(cgColor: Tools.cgColor("#F7F7F7")))
//        .background(Color(red: 247/255, green: 247/255, blue: 247/255))  //设置背景色
        .ignoresSafeArea(.all,edges: [.bottom]) //忽略底部的 安全区域
//        Spacer()
//


    }
}

//#Preview {
//    YYSwiftPage()
//}
 
