//
//  ViewController.swift
//  EmotionsTest
//
//  Created by Tsz on 15/10/17.
//  Copyright © 2015年 Tsz. All rights reserved.

import UIKit

class ViewController: UIViewController {

    //使用stordboard 去连线
    //我们需要自己去自定义键盘
    
    private lazy var emoticonView:EmoticonViewController = EmoticonViewController()
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emoticonView.view.backgroundColor  = UIColor.whiteColor()
        textView.inputView = emoticonView.view
    }


}

