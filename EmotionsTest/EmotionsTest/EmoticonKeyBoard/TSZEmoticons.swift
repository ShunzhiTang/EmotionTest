/**
1. Emoticons.bundle的根目录中有一个 emoticons.plist
packages数组的每一项字典中的 id 对应的是每一套表情的目录名
2. 每一个表情目录下，都有一个 info.plist 文件
group_name_cn 记录的表情包的名字
emoticons 数组，记录的整套表情的数组
3. 表情字典信息
chs:    定义的发布微博以及网络传输使用的微博文字字符串
png:    在客户端显示的图片名称

code:   emoji要显示的16进制字符串！
*/

import UIKit


class TSZEmoticonsPackage: NSObject {
    //存储表情包的目录名
    var id: String
    //分组名,是我们想要得到的 ，但是他存储在 各个表情的plist文件中
    var groupName: String = ""
    
    //把整个表情数组存储作为这个包属性 ， 这样可以实现更好的 模型 ，类似于 模型的嵌套
    var emoticons: [TSZEmoticons]?
    
    init(id: String) {
        self.id = id
    }
    
    //加载所有的表情包
    class func packages() -> [TSZEmoticonsPackage]{
        //1、加载路径
        let path = bundlePath.stringByAppendingString("/emoticons.plist")
        //2、加载list
        let dict = NSDictionary(contentsOfFile: path)!
        let array = dict["packages"] as! [[String : AnyObject]]
        
        //3、遍历数组
        var arrayM = [TSZEmoticonsPackage]()
        
        for d  in array {
            let id = d["id"] as! String
            //链式响应
            let package = TSZEmoticonsPackage(id: id).loadEmoticons()
            
            arrayM.append(package)
        }
        
        return arrayM
    }
    //加载当前对象对应的表情数组 ， 从info.plist 中加载并完成的模型信息
    func loadEmoticons() ->Self {
        //1、路径
        let path = TSZEmoticonsPackage.bundlePath.stringByAppendingString("/\(id)").stringByAppendingString("/info.plist")
        
        let dict = NSDictionary(contentsOfFile: path)!
        
        groupName = dict["group_name_cn"] as! String
        let array = dict["emoticons"] as! [[String : String]]
        
        //2、遍历数组
        emoticons = [TSZEmoticons]()
        for d in array {
            
            
            emoticons?.append(TSZEmoticons(id: id , dict:d))
        }
        return self
    }
    
    //表情包的路径
    static let bundlePath = NSBundle.mainBundle().bundlePath.stringByAppendingString("/Emoticons.bundle")
    
    override var description: String {
        return "\(id) \(groupName) \(emoticons)"
    }
}

//MARK: - 表情模型 （包括emoji  、 默认 、 浪小花）
class TSZEmoticons: NSObject {
    
    // 设置属性
    
    //表情目录，com.sina.lagnxiaohua ，三种表情的三个id
    var id: String?
    /// 默认表情发送到网上的表情文字
    var chs: String?
    /// 本地显示的图片名
    var png: String?
    
    var imagePath: String {
        //判断是否是hi 图片
        if  chs == nil{
            return ""
        }
        
        //path + id + png
        return  TSZEmoticonsPackage.bundlePath.stringByAppendingString("/\(id!)").stringByAppendingString("/\(png!)")
        
    }
    
    //把图片的 数据都放在 model中 ，通过code 给emoji 复制
    var code: String? {
        didSet {
            //扫描器  ，把一个16进制的字符转换为字符串
            let scanner = NSScanner(string: code!)
            
            var value: UInt32 = 0
            scanner.scanHexInt(&value)
            emoji = String(Character(UnicodeScalar(value)))
        }
    }
    
    var emoji: String?
    
    //重写字典转模型的方法
    init(id: String , dict: [String : String]){
        //TODO: 这里一定要 确定 id要关联 ，这是 唯一的标识
        self.id = id
        super.init()
        //字典转模型
        setValuesForKeysWithDictionary(dict)
    }
    /**
    * 实现下列方法可以实现 属性 和 key 不一致也可以进行字典转模型
    */
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {}
    
    //写一个输出的方法
    override var description: String{
        return "\(chs) \(png) \(code))"
    }
}
