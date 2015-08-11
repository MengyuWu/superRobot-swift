//
//  ConnectViewController.swift
//  superRobotSwift
//
//  Created by 吴梦宇 on 8/6/15.
//  Copyright (c) 2015 ___mengyu wu___. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController, NSStreamDelegate  {
    
   // let VideoUrlAddress="http://192.168.0.103:5555"
    let VideoUrlAddress="http://youtube.com"
    var inputStream:NSInputStream?
    var outputStream:NSOutputStream?
    var messages=NSMutableArray()
    
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var controlView: UIView!
    
    
    @IBOutlet weak var IPTextField: UITextField!
    @IBOutlet weak var PortTextField: UITextField!
    
    @IBOutlet weak var webView: UIWebView!
 
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var velocitySlider: UISlider!

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
        var urlAddress=VideoUrlAddress
        var url=NSURL(string: urlAddress)
        let request = NSURLRequest(URL: url!)
        webView.loadRequest(request)
        
        //Keyboard dismiss
        self.IPTextField.delegate=self
        self.PortTextField.delegate=self
        
    }

    @IBAction func refreshWebview(sender: AnyObject) {
        var urlAddress=VideoUrlAddress
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
            webView.reload()
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
        println("passive")
        sendMessage("passive")
    }
   
    
    @IBAction func safeButtonTapped(sender: AnyObject) {
        println("safe")
        sendMessage("safe")
        
    }
    

    @IBAction func fullButtonTapped(sender: AnyObject) {
        println("full")
        sendMessage("full")
        
    }
    
    

    @IBAction func cleanButtonTapped(sender: AnyObject) {
        println("clean")
        sendMessage("clean")
    }
    
    
    @IBAction func dockButtonTapped(sender: AnyObject) {
        println("dock")
        sendMessage("dock")
    }
    
    
    @IBAction func beepButtonTapped(sender: AnyObject) {
        println("beep")
        sendMessage("beep")
    }

    
    // LEFT
    @IBAction func leftButtonTouchUpInside(sender: AnyObject) {
       println("left down")
        sendMessage("stop")
    }
    

    @IBAction func leftButtonTouchBegin(sender: AnyObject) {
        println("left up")
        sendMessage("leftButtonDown")
        
    }
    

    //RIGHT
    
    @IBAction func rightTouchDown(sender: AnyObject) {
        println("right down")
        sendMessage("rightButtonDown")
    }
    
    @IBAction func rightTouchUpInside(sender: AnyObject) {
        println("right up")
        sendMessage("stop")
    }
    
    
    
    // UP
    
    @IBAction func upTouchDown(sender: AnyObject) {
        println("up button down")
        sendMessage("upButtonDown")
    }
    
    @IBAction func upTouchUpInside(sender: AnyObject) {
         println("up button up")
        sendMessage("stop")
    }
    
    // DOWN
    
    
    @IBAction func downTouchDown(sender: AnyObject) {
        println("down button down")
        sendMessage("downButtonDown")
    }
    
    @IBAction func downTouchUpInside(sender: AnyObject) {
        println("down button up")
         sendMessage("stop")
    }
    
    
    
    
    @IBAction func stopButtonTapped(sender: AnyObject) {
        //sendMessage("stop")
        inputStream?.close()
        outputStream?.close()
        
        self.loginView.hidden=false
        self.controlView.hidden=true
    

    }
    
    
    @IBAction func sliderValueChanged(sender:UISlider) {
        var currentValue = Int(sender.value)
        valueLabel.text="\(currentValue)"
       
    }
    
    
    
    @IBAction func sliderDidEndChange(sender:UISlider) {
      
          var currentValue = Int(sender.value)
          println("did end change value: \(currentValue)")
          sendMessage("V:\(currentValue)")
        
    }
      
}

extension ConnectViewController: UITextFieldDelegate{
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}