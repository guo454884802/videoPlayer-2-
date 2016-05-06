//
//  registerTableViewController.swift
//  videoPlayer
//
//  Created by  wj on 15/12/11.
//  Copyright © 2015年 gzq. All rights reserved.
//

import UIKit
import AJWValidator


class registerTableViewController: UITableViewController {

    var doneButton:UIBarButtonItem?
    
    @IBOutlet weak var user: UITextBox!
    @IBOutlet weak var pass: UITextBox!
    @IBOutlet weak var rewritePass: UITextBox!
    
    var possibleInput:Inputs = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBarHidden = false
        self.title = "注册"
        
        pass.secureTextEntry = true
        rewritePass.secureTextEntry = true 
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneButtonTap")
        self.navigationItem.rightBarButtonItem?.enabled = false
         doneButton = self.navigationItem.rightBarButtonItem
        
        
        let v1 = AJWValidator(type: .String)
        v1.addValidationToEnsureMinimumLength(3, invalidMessage: "用户名至少3位")
        v1.addValidationToEnsureMaximumLength(15, invalidMessage: "用户名最长15位")
        self.user.ajw_attachValidator(v1)
        
        v1.validatorStateChangedHandler = { (newState:AJWValidatorState) -> Void in
            switch newState{
            case .ValidationStateValid:
                self.user.highlightState = UITextBoxHighlightState.Default
                
                self.possibleInput.unionInPlace(Inputs.user)
                
            default:
                let errorMsg = v1.errorMessages.first as? String
                let a = UITextBoxHighlightState.Wrong(errorMsg!)
                self.user.highlightState = a
                
                self.possibleInput.subtractInPlace(Inputs.user)
                
            }
            self.doneButton?.enabled = self.possibleInput.isAllOK()
        }
        
        let v2 = AJWValidator(type: .String)
        v2.addValidationToEnsureMinimumLength(3, invalidMessage: "密码至少3位")
        v2.addValidationToEnsureMaximumLength(15, invalidMessage: "密码最长15位")
        self.pass.ajw_attachValidator(v2)
        
        v2.validatorStateChangedHandler = {(newState:AJWValidatorState) -> Void in
            switch newState{
            case AJWValidatorState.ValidationStateValid:
                self.pass.highlightState = UITextBoxHighlightState.Default
                
                 self.possibleInput.unionInPlace(Inputs.pass)
                
            default:
                let errorMsg = v2.errorMessages.first as? String
                self.pass.highlightState = UITextBoxHighlightState.Wrong(errorMsg!)
                
                self.possibleInput.subtractInPlace(Inputs.pass)
                
            }
           self.doneButton?.enabled = self.possibleInput.isAllOK()
        }
        let v3 = AJWValidator(type: .String)
        v3.addValidationToEnsureMinimumLength(3, invalidMessage: "密码至少3位")
        v3.addValidationToEnsureMaximumLength(15, invalidMessage: "密码最长15位")
        self.rewritePass.ajw_attachValidator(v3)
        
        v3.validatorStateChangedHandler = {(newState:AJWValidatorState) -> Void in
            switch newState{
            case AJWValidatorState.ValidationStateValid:
                self.rewritePass.highlightState = UITextBoxHighlightState.Default
                
                self.possibleInput.unionInPlace(Inputs.rewirePass)
                
            default:
                let errorMsg = v3.errorMessages.first as? String
                self.rewritePass.highlightState = UITextBoxHighlightState.Wrong(errorMsg!)
                
                self.possibleInput.subtractInPlace(Inputs.rewirePass)

                
            }
            
           self.doneButton?.enabled = self.possibleInput.isAllOK()
        }


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    func doneButtonTap(){
        
        self.pleaseWait()
        if pass.text != rewritePass.text{
            self.clearAllNotice()
            self.errorNotice("密码不一致")
            self.rewritePass.becomeFirstResponder()
            self.doneButton?.enabled = false
            return
        }
        //建立用户的AVObject
        let user = AVObject(className: "GZQUser")
        //把输入的文本框的值，设置到对象中
        user["user"] = self.user.text
        user["pass"] = self.pass.text
        
        //查询用户是否已经注册
        let query = AVQuery(className: "GZQUser")
        query.whereKey("user", equalTo: self.user.text)
        
        //执行查询
        query.getFirstObjectInBackgroundWithBlock { (object, e) -> Void in
            self.clearAllNotice()
            if object != nil{
                self.errorNotice("用户已注册")
                self.user.becomeFirstResponder()
                self.doneButton!.enabled = false
            }else{
                user.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success{
                        self.successNotice("注册成功")
                        self.navigationController?.popViewControllerAnimated(true)
                    }else{
                        
                    }
                })
            }
        }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
