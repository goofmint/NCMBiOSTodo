//
//  MasterViewController.swift
//  NCMBiOS_Todo
//
//  Created by naokits on 6/6/15.
//

import UIKit

class MasterViewController: UITableViewController {

    let kTodoClassName = "Todo"
    
    /// TODOを格納する配列です。実際にはNCMBObjectを格納します。
    var objects = [AnyObject]()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.fetchAllTodos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // ------------------------------------------------------------------------
    // MARK: - Segues
    // ------------------------------------------------------------------------

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editTodo" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = self.objects[indexPath.row] as! NCMBObject
                if let dvc = segue.destinationViewController as? DetailViewController {
                    dvc.detailItem = object
                    dvc.updateButton.title = "更新"
                }
            }
        } else if segue.identifier == "addTodo" {
            (segue.destinationViewController as! DetailViewController).updateButton.title = "追加"
        } else {
            // 遷移先が定義されていない
        }
    }
    
    /// TODO登録／編集画面から戻ってきた時の処理を行います。
    /// 今回はUnwind Identifierは必要ないので定義してません。
    @IBAction func backFromTodoEdit(segue:UIStoryboardSegue) {
        let svc = segue.sourceViewController as! DetailViewController
        println("戻り: \(svc.detailItem)")
        if svc.detailItem == nil {
            println("TODOオブジェクトが存在しないので、新規とみなします。")
            self.addTodoWithTitle(svc.todoTitle.text)
        } else {
            println("更新処理")
            svc.detailItem?.setObject(svc.todoTitle.text, forKey: "title")
            svc.detailItem?.saveInBackgroundWithBlock({ (error: NSError!) -> Void in
                self.tableView.reloadData()
            })
        }
    }
    
    // ------------------------------------------------------------------------
    // MARK: - Table View
    // ------------------------------------------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object: (AnyObject) = objects[indexPath.row]
        cell.textLabel!.text = object.objectForKey("title") as? String
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let object = objects[indexPath.row] as! NCMBObject
            let objectID = object.objectForKey("objectId") as! String
            
            let query = NCMBQuery(className: kTodoClassName)
            query.getObjectInBackgroundWithId(objectID, block: { (object: NCMBObject!, fetchError: NSError?) -> Void in
                if fetchError == nil {
                    // NCMBから非同期で対象オブジェクトを削除します
                    // TODO: 削除は同期処理に変更するか再考する。
                    object.deleteInBackgroundWithBlock({ (deleteError: NSError!) -> Void in
                        if (deleteError == nil) {
                            let deletedObject = self.objects.removeAtIndex(indexPath.row) as! NCMBObject
                            println("削除したオブジェクトの情報: \(deletedObject)")
                            // データソースから削除
                            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        } else {
                            println("削除失敗: \(deleteError)")
                        }
                    })
                } else {
                    println("オブジェクト取得失敗: \(fetchError)")
                }
            })
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // ------------------------------------------------------------------------
    // MARK: Methods for Data Source
    // ------------------------------------------------------------------------

    /// 全てのTODO情報を取得し、プロパティに格納します
    ///
    /// :param: None
    /// :returns: None
    func fetchAllTodos() {
        var query = NCMBQuery(className: kTodoClassName)
        // タイトルにデータが含まれないものは除外
        query.whereKeyExists("title")
        // 登録日の降順で取得
        query.orderByDescending("createDate")
        // 取得件数の指定
        query.limit = 10

        query.findObjectsInBackgroundWithBlock({(NSArray todos, NSError error) in
            if (error == nil) {
                println("登録件数: \(todos.count)")
                for todo in todos {
                    let title: AnyObject? = todo.objectForKey("title")
                    println("--- \(todo.objectId): \(title)")
                }
                self.objects = todos
                self.tableView.reloadData()
            } else {
                println("Error: \(error)")
            }
        })
    }

    /// 新規にTODOを追加します
    ///
    /// :param: title TODOのタイトル
    /// :returns: None
    func addTodoWithTitle(title: String) {
        let obj = NCMBObject(className: "Todo") as NCMBObject
        obj.setObject(title, forKey: "title")
        // 非同期で保存
        obj.saveInBackgroundWithBlock { (error: NSError!) -> Void in
            if(error == nil){
                println("新規TODOの保存成功。表示の更新などを行う。")
                self.insertNewTodoObject(obj)
            } else {
                println("新規TODOの保存に失敗しました: \(error)")
            }
        }
    }
    
    /// TODOをDataSourceに追加して、表示を更新します
    ///
    /// :param: todo TODOオブジェクト（NCMBObject）
    /// :returns: None
    func insertNewTodoObject(todo: AnyObject) {
        self.objects.insert(todo as! (NCMBObject), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.reloadData()
    }
}

