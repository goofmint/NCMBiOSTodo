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

    /// TODOオブジェクトの内容
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    /// 追加/更新共用ボタン
    @IBOutlet weak var updateButton: UIBarButtonItem!
    
    // TODOオブジェクト
    var detailItem: NCMBObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    /// 追加/更新共用ボタンがタップされた時に呼び出されます。
    @IBAction func tappedUpdateButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.description
            }
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

