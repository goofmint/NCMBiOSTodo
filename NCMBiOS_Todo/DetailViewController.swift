//
//  DetailViewController.swift
//  NCMBiOS_Todo
//
//  Created by naokits on 6/6/15.
//

import UIKit

class DetailViewController: UIViewController {
    /// TODOのタイトル
    @IBOutlet weak var todoTitle: UITextField!

    var detailItem: NCMBObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    @IBAction func tappedUpdateButton(sender: AnyObject) {
        println("更新ボタン")
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("完了")
        })
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let title = self.todoTitle {
                title.text = detail.objectForKey("title") as! String
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

