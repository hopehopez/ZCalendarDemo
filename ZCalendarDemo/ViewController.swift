//
//  ViewController.swift
//  ZCalendarDemo
//
//  Created by zsq on 2018/5/3.
//  Copyright © 2018年 zsq. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var calendar: ZCalendar!
    @IBOutlet weak var dateLb: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dateLb.text  = calendar.currentDateString(withFormat: "yyyy年MM月")
        calendar.calendarDelegate = self
    }

    @IBAction func next(_ sender: UIButton) {
        calendar.display(in: .next)
    }
    @IBAction func last(_ sender: UIButton) {
        calendar.display(in: .previous)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ZCalendarDelegate {
    func calendar(_ calendar: ZCalendar, current dateString: String) {
        dateLb.text = dateString
    }
    func calendar(_ calendar: ZCalendar, didSelect date: Date?, forItemAt indexPath: IndexPath) {
        
    }
}

