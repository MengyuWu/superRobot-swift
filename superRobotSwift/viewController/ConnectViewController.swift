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
//        loginView.hidden=true
//        controlView.hidden=false
        
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

        loginView.hidden=false
        controlView.hidden=true
        var urlAddress="http://192.168.0.103:5555"
        var url=NSURL(string: urlAddress)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        println("stream event: \(eventCode)")
        
        switch (eventCode) {
       
        case NSStreamEvent.OpenCompleted:
            println("Stream opened")
            loginView.hidden=true
            controlView.hidden=false
            break
            
        case NSStreamEvent.HasBytesAvailable:
            println("HasBytesAvailable")
            break
            
        case NSStreamEvent.ErrorOccurred:
            println("Can not connect to the host!")
            break
            
        case NSStreamEvent.EndEncountered:
            aStream.close()
            aStream.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            break
            
        default:
           println("unknown event")
        }

        
    
    }
    
    func sendMessage(msg:String){
        var data = NSData(data: msg.dataUsingEncoding(NSASCIIStringEncoding)!)
        outputStream?.write(UnsafePointer<UInt8>(data.bytes) , maxLength: data.length)
    }
    
    func getCurrentSecond(date:NSDate)-> Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond | .CalendarUnitNanosecond , fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        let seconds = components.second
        let nanoseconds=components.nanosecond
        return nanoseconds
    }
    
    @IBAction func passiveButtonTapped(sender: AnyObject) {
        sendMessage("passive")
    }
   
    
    @IBAction func safeButtonTapped(sender: AnyObject) {
        sendMessage("safe")
        
    }
    

    @IBAction func fullButtonTapped(sender: AnyObject) {
        sendMessage("full")
        
    }
    
    

    @IBAction func cleanButtonTapped(sender: AnyObject) {
        sendMessage("clean")
    }
    
    
    @IBAction func dockButtonTapped(sender: AnyObject) {
        sendMessage("dock")
    }
    
    
    @IBAction func beepButtonTapped(sender: AnyObject) {
        sendMessage("beep")
    }

    
    // LEFT
    @IBAction func leftButtonTouchUpInside(sender: AnyObject) {
        
        let nanoseconds = getCurrentSecond(NSDate())
        println("touch up inside, left move stop, time: \(nanoseconds)")
        sendMessage("stop")
    }
    

    @IBAction func leftButtonTouchBegin(sender: AnyObject) {
     let nanoseconds = getCurrentSecond(NSDate())
        println("touch down, left move begin, time: \(nanoseconds)")
        sendMessage("leftButtonDown")
        
    }
    

    //RIGHT
    
    @IBAction func rightTouchDown(sender: AnyObject) {
        sendMessage("rightButtonDown")
    }
    
    @IBAction func rightTouchUpInside(sender: AnyObject) {
        sendMessage("stop")
    }
    
    
    
    // UP
    
    @IBAction func upTouchDown(sender: AnyObject) {
        sendMessage("upButtonDown")
    }
    
    @IBAction func upTouchUpInside(sender: AnyObject) {
        sendMessage("stop")
    }
    
    // DOWN
    
    
    @IBAction func downTouchDown(sender: AnyObject) {
        sendMessage("downButtonDown")
    }
    
    @IBAction func downTouchUpInside(sender: AnyObject) {
         sendMessage("stop")
    }
    
    
    
    
    @IBAction func stopButtonTapped(sender: AnyObject) {
        sendMessage("stop")
    }
    
    @IBAction func doneButtonTapped(sender: AnyObject) {
        inputStream?.close()
        outputStream?.close()
        
        self.loginView.hidden=false
        self.controlView.hidden=true
    }
    
}
