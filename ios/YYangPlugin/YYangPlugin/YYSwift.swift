//
//  YYSwift.swift
//  YYangPlugin
//
//  Created by mt on 2025/3/12.
//

import Foundation

import SwiftUI
import UIKit

// 必须继承自 NSObject 或 UIViewController，并标记为 @objc 和 public
//@objc public class YYSwift: UIViewController {
//    @objc public override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        let label = UILabel(frame: CGRect(x: 0, y: 100, width: 200, height: 30))
//        label.text = "来自插件的 Swift 页面"
//        view.addSubview(label)
//        
//    }
//}

@available(iOS 15.0, *)
@objc public class YYSwift: UIViewController {  // ✅ 改为继承 UIViewController
    private let hostingVC: UIHostingController<YYSwiftPage>
    
    // MARK: - 初始化
    @objc public init(message: NSString) {
        let swiftMessage = message as String
        self.hostingVC = UIHostingController(rootView: YYSwiftPage(message: swiftMessage))
        super.init(nibName: nil, bundle: nil)
        
        // 添加 SwiftUI 控制器为子控制器
        self.addChild(hostingVC)
        hostingVC.view.frame = self.view.bounds
        hostingVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(hostingVC.view)
        hostingVC.didMove(toParent: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomBackButton()
        setupNavigationBarAppearance()
    }

    // MARK: - 导航栏支持
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.title = "SwiftUI 页面"
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 恢复原始导航栏状态
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    private func setupCustomBackButton() {
        // 设置返回按钮图像
        let backImage = UIImage(systemName: "chevron.left")?.withTintColor(.white, renderingMode: .alwaysOriginal) // 关键修改

        let backButton = UIBarButtonItem(image: backImage, style:.plain, target: self.navigationController, action: #selector(UINavigationController.popViewController(animated:)))
        self.navigationItem.leftBarButtonItem = backButton
        
        // 隐藏返回按钮文字
        let appearance = UINavigationBarAppearance()
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
 
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        // 设置导航栏背景颜色为蓝色
//        appearance.backgroundColor = UIColor(red: 64.0/255, green: 156.0/255, blue: 255.0/255, alpha: 1.0)
        appearance.backgroundColor = UIColor(red: 10.0/255, green: 132.0/255, blue: 255.0/255, alpha: 1.0)
        // 显示底部的线
        appearance.shadowColor = .lightGray
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        // 设置返回按钮颜色为白色
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backButtonAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }


}

