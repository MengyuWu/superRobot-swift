//
//  ConnectViewController.swift
//  superRobotSwift
//
//  Created by 吴梦宇 on 8/6/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController, NSStreamDelegate  {
    
    var inputStream:NSInputStream?
    var outputStream:NSOutputStream?
    var messages=NSMutableArray()
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var controlView: UIView!
    
    
    @IBOutlet weak var IPTextField: UITextField!
    @IBOutlet weak var PortTextField: UITextField!
    
 

    @IBAction func ConnectButtonPressed(sender: AnyObject) {
        
        var ip:CFStringRef=IPTextField.text
        var port:UInt32=UInt32(PortTextField.text.toInt() ?? 9000)
        
        println("ip: \(ip) port: \(port)")
        
        initNetworkCommunication(ip, port: port)
        
        //TODO: check whether it is connect to server
        // if connect
        loginView.hidden=true
        controlView.hidden=false
        
    }
    
    func initNetworkCommunication(ip:CFStringRef, port: UInt32){
        
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(nil, ip, port, &readStream, &writeStream)
        
        self.inputStream = readStream!.takeRetainedValue()
        self.outputStream = writeStream!.takeRetainedValue()
        
        self.inputStream!.delegate = self
        self.outputStream!.delegate = self
        
        self.inputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        self.outputStream!.scheduleInRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        
        self.inputStream!.open()
        self.outputStream!.open()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
