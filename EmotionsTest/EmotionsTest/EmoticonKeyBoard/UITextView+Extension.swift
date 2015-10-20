//
//  UITextView+Extension.swift
///  表情键盘的实现


import UIKit

extension UITextView{
    //插入我们的每一个每一个点击的表情
    func insertEmoticon(emoticon: TSZEmoticons){
        //emoji本质是一个字符串
        if emoticon.emoji != nil{
            replaceRange(selectedTextRange!, withText: emoticon.emoji!)
            
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
            let hight = font?.lineHeight
            
            //设置 文字属性的大小
            attachment.bounds = CGRect(x: 0, y: -4, width: hight!, height: hight!)
            
            //图文混排
            let imageText = NSMutableAttributedString(attributedString: NSAttributedString(attachment: attachment))
            
            //图片添加到属性
            imageText.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, 1))
            
            
            //MARK: 图片文字插入到textView
            //1、获取 可变的文字属性
            let attrString = NSMutableAttributedString(attributedString: attributedText)
            
            //2、插入图片文字
            attrString.replaceCharactersInRange(selectedRange, withAttributedString: imageText)
            
            
            //3、 使用 可变属性文本 替换文本试图
            //光标的位置
            let range = selectedRange
            //设置内容
            attributedText = attrString
            
            //恢复光标的位置
            selectedRange = NSRange(location: range.location + 1, length: 0)
            
        }
        
        //我是删除键盘
        if emoticon.removeEmotion  {
            print("我是删除按钮")
            //            deleteBackward()
        }
    }
    
    var EmoticonsText: String {
    /**
    * 属性的保存
    */
    let attrString = attributedText
    
    var strM  =  String()
    
    attrString.enumerateAttributesInRange(NSMakeRange(0, attrString.length), options: NSAttributedStringEnumerationOptions(rawValue: 0)) { (dict, range, _) -> Void in
    
    if let attrachment = dict["NSAttachment"] as? TSZEmoticonsAttachment{
    
    
    strM += attrachment.chs!
    } else {
    //使用range获取文本文字
    let str = (attrString.string as NSString).substringWithRange(range)
    
    strM += str
    }
    }
        return strM
        
}
}
