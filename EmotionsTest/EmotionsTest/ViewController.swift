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
        
            print("回调 \(emoticon.emoji) ")
        //拿到数据之后我们需要去完成的就是，把数据显示出来，但是textView的显示 是  使用 attributedText 富文本属性去完成的 ，，所以我们 要 设置 这个属性
        
        self?.insertEmoticon(emoticon)
          }
    
    
    @IBOutlet weak var textKeyView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textKeyView.inputView = emoticonView.view
        
    }
    
    //插入我们的每一个每一个点击的表情
    func insertEmoticon(emoticon: TSZEmoticons){
        //emoji本质是一个字符串
        if emoticon.emoji != nil{
            textKeyView.replaceRange(textKeyView.selectedTextRange!, withText: emoticon.emoji!)
            
            return
        }
        
        //如果是表情图片，需要去拿到本地的图片
        if emoticon.chs != nil{
            
            //MARK: 难点：   富文本属性
            //  1、创建图片属性的字符串
            let attachment  = TSZEmoticonsAttachment()
            
            //2、记录默认的表情文字
            attachment.chs  = emoticon.chs
            //表情文字 对应的文字
            attachment.image = UIImage(contentsOfFile: emoticon.imagePath)
            
            //3、设置边界
            let hight = textKeyView.font?.lineHeight
            
            //设置 文字属性的大小
            attachment.bounds = CGRect(x: 0, y: -4, width: hight!, height: hight!)
            
            //图文混排
            let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            
            //图片添加到属性
            imageText.addAttribute(NSFontAttributeName, value: textKeyView.font!, range: NSMakeRange(0, 1))
            
            
            //MARK: 图片文字插入到textView
            //1、获取 可变的文字属性
            let attrString = NSMutableAttributedString(attributedString: textKeyView.attributedText)
            
            //2、插入图片文字
            attrString.replaceCharactersInRange(textKeyView.selectedRange, withAttributedString: imageText)
            
            
            //3、 使用 可变属性文本 替换文本试图
            //光标的位置
            let range = textKeyView.selectedRange
            //设置内容
            textKeyView.attributedText = attrString
            
            //恢复光标的位置
            textKeyView.selectedRange = NSRange(location: range.location + 1, length: 0)
            
        }
    }
    
    
    @IBAction func outputText(sender: UIButton) {
        
        /**
        * 属性的保存
        */
        let attrString =  textKeyView.attributedText
        
        var strM  =  String()
        
        attrString.enumerateAttributesInRange(NSMakeRange(0, attrString.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
            
            if let attrachment = dict["NSAttachment"] as? TSZEmoticonsAttachment{
                    print("配图\(attrachment.chs)")
                
                strM += attrachment.chs!
            } else {
                //使用range获取文本文字
                let str = (attrString.string as NSString).substringWithRange(range)
                
                strM += str
            }
        }
           print("打印的结果： \(strM)")
    }
    deinit{
            print("dismiss")
    }
}


