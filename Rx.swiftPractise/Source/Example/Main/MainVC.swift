//
//  MainVC.swift
//  Rx.swiftPractise
//
//  Created by 白海瑞 on 2018/8/10.
//  Copyright © 2018年 Rx.Swift. All rights reserved.
//

import UIKit
//import Rswift
import RxSwift
import Alamofire

class MainVC: BaseController {

    
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        SessionManager.default.rx
            .modelSerializer("")
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (models:[MainModel] , _) in
                //获取数据模型
            }, onError: { (error) in
                
            }).disposed(by: disposeBag)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
