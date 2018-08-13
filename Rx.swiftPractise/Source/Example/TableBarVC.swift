//
//  TableBarVC.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/11.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import UIKit

class TableBarVC: BaseTableBarVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainVC = BaseNavigationVC(rootViewController: MainVC())
        let personalVC = BaseNavigationVC(rootViewController: PersonalVC())
        mainVC.title = "主页"
        personalVC.title = "个人中心"
        self.viewControllers = [mainVC,personalVC]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
