//
//  EmoticonViewController.swift
//  EmotionsTest
//
//  Created by Tsz on 15/10/17.
//  Copyright © 2015年 Tsz. All rights reserved.
//

import UIKit

class EmoticonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //设置UI
        setupUI()
        
    }
    
    //MARK - 设置 UI
    private func setupUI(){
        //添加 控件
        view.addSubview(toolsBar)
        
        //自动布局
        toolsBar.translatesAutoresizingMaskIntoConstraints = false
//        view.addConstraint(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[subview]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["subview" : view]))
//        
        
        //准备控件
        prepareToolsBar()
        
    }
    //准备ToolsBar
    private func prepareToolsBar(){
        
        var items = [UIBarButtonItem()];
        //为了区分 加tag值
        var index = 0
        for bar in ["最近","默认","Emoji","浪小花"] {
            items.append(UIBarButtonItem(title: bar, style: UIBarButtonItemStyle.Plain, target: self, action: "clickEmotion" ))
            items.last?.tag = index++
            //加个弹簧分开
            items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
        }
        //去掉最后一个弹簧
        items.removeLast()
        toolsBar.items = items
    }
    
    
    //toolsBar
    
    //MARK - 懒加载
    private lazy var toolsBar: UIToolbar = {
        let tb = UIToolbar()
        
        tb.tintColor = UIColor.darkGrayColor()
        return tb
        
        }()
}
