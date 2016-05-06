//
//  loginViewController.swift
//  videoPlayer
//
//  Created by  wj on 15/12/10.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit

extension UIView{
   @IBInspectable var cornerRadius:CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
            layer.masksToBounds = (newValue > 0)
        }
    }
}

class loginViewController: UIViewController {

    var count:Int = 0
    var urls:[String]?
    
    @IBOutlet weak var loginImage: UIImageView!
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: .Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        loginImage.addSubview(blurEffectView)
        //输入的文字变成星号，密码输入
        passText.secureTextEntry = true
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginButtom(sender: UIButton) {
        
        let query = AVQuery(className: "GZQUser")
        query.whereKey("user", equalTo: self.userText.text)
        
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if object == nil {
                self.errorNotice("用户名不存在", autoClear: true)
            }else{
                
                query.whereKey("pass", equalTo: self.passText.text)
                query.getFirstObjectInBackgroundWithBlock({ (object2, error2) -> Void in
                    if object2 == nil{
                        self.errorNotice("密码错误", autoClear: true)
                    }else{
                        self.performSegueWithIdentifier("loginSegue", sender: nil)
                    }
                })
            }
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        passText.resignFirstResponder()
    }

    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
              // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
