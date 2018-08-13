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
        var manager = SessionManager.default
        manager.rx.modelSerializer("").observeOn(MainScheduler)
        manager.rx.modelSerializer("").subscribe(onNext: { (model:MainModel) in
            //获取模型
        }, onError: { (error) in
            //错误类型
        }).disposed(by: disposeBag)
        

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
