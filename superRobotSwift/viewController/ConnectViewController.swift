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
    
    @IBOutlet weak var webView: UIWebView!
 

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

     
        var urlAddress="https://www.youtube.com"
        var url=NSURL(string: urlAddress)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
    
    }
}
