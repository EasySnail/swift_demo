//
//  PlayerDefinition.swift
//  Player
//
//  Created by Easy on 2017/12/7.
//  Copyright © 2017年 Easy. All rights reserved.
//

import Foundation


let KSCREENWIDTH = UIScreen.main.bounds.size.width
let KSCREENEHEIGHT = UIScreen.main.bounds.size.height
let kNavigationHeight = UIApplication.shared.statusBarFrame.size.height + 44.0
let kTabarHeight = UIScreen.main.bounds.size.height == 812.0 ? 83.0 : 49.0


func RGBColor(_ rgbValue:Int) -> UIColor{
    return UIColor(displayP3Red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgbValue & 0xFF))/255.0, alpha: 1.0)
}


func ERectMake(_ x:CGFloat, _ y:CGFloat ,_ width:CGFloat, _ heigth:CGFloat) -> CGRect {
    return CGRect(x: x, y: y, width: width, height: heigth)
}

//命名空间
var ENameSpace:String = {
    guard let nameSpace = Bundle.main.infoDictionary!["CFBundleExecutable"] else {
        return "Player"
    }
    return nameSpace as! String
}()




extension UIView{
    var e_x:CGFloat{
        get{
            return self.frame.origin.x
        }
    }
    var e_y:CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var rect = self.frame
            rect.origin.y = newValue
            self.frame = rect
        }
    }
    var e_width:CGFloat{
        get{
            return self.frame.size.width
        }
    }
    var e_height:CGFloat{
        get{
            return self.frame.size.height
        }
    }
}

extension String{
    var md5_string:String{
        let str = self.cString(using: .utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: .utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        return String(format: hash as String)
    }
}
