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
    
   
    private lazy var emoticonView: EmoticonViewController = EmoticonViewController{
        
        //解决循环引用的问题
        [weak self](emoticon) -> ()  in
        
//            print("回调 \(emoticon.emoji) ")
        //拿到数据之后我们需要去完成的就是，把数据显示出来，但是textView的显示 是  使用 attributedText 富文本属性去完成的 ，，所以我们 要 设置 这个属性
        
        self!.textKeyView.insertEmoticon(emoticon)
          }
    
    
    @IBOutlet weak var textKeyView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textKeyView.inputView = emoticonView.view
        
    }
    
    @IBAction func outputText(sender: UIButton) {
        
           print("打印的结果： \(textKeyView.EmoticonsText)")
    }
    
    deinit{
            print("dismiss")
    }
}


