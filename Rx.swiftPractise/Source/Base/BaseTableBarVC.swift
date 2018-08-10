//
//  BaseTableBarVC.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/10.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import UIKit

class BaseTableBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        initTheme()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BaseTableBarVC :Themed {
    
    func applyTheme(_ theme: AppThemes) {
        tabBar.barTintColor = theme.barBackgroundColor
        tabBar.tintColor = theme.barForegroundColor
    }
}
