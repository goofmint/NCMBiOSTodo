//
//  MasterViewController.swift
//  NCMBiOS_Todo
//
//  Created by naokits on 6/6/15.
//

import UIKit

class MasterViewController: UITableViewController {

    /// TODOを格納する配列
    var objects = [Todo]()

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
                let todo = self.objects[indexPath.row]
                if let dvc = segue.destinationViewController as? DetailViewController {
                    dvc.detailItem = todo
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

        if svc.detailItem == nil {
            println("TODOオブジェクトが存在しないので、新規とみなします。")
            self.addTodoWithTitle(svc.todoTitle.text)
        } else {
            println("更新処理")
            svc.detailItem?.title = svc.todoTitle.text
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

        let todo = objects[indexPath.row]
        cell.textLabel?.text = todo.title
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let todo = objects[indexPath.row] as NCMBObject
            let objectID = todo.objectId
            
            let query = Todo.query()
            query.getObjectInBackgroundWithId(objectID, block: { (object: NCMBObject!, fetchError: NSError?) -> Void in
                if fetchError == nil {
                    // NCMBから非同期で対象オブジェクトを削除します
                    object.deleteInBackgroundWithBlock({ (deleteError: NSError!) -> Void in
                        if (deleteError == nil) {
                            let deletedObject = self.objects.removeAtIndex(indexPath.row)
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
        let query = Todo.query()
        // タイトルにデータが含まれないものは除外（空の文字列は除外されない）
        query.whereKeyExists("title")
        // 登録日の降順で取得
        query.orderByDescending("createDate")
        // 取得件数の指定
        query.limit = 20

        query.findObjectsInBackgroundWithBlock({(NSArray todos, NSError error) in
            if (error == nil) {
                println("登録件数: \(todos.count)")
                for todo in todos {
                    let title = todo.title
                    println("--- \(todo.objectId): \(title)")
                }
                self.objects = todos as! [Todo] // NSArray -> Swift Array
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
        let todo = Todo.object() as! Todo
        todo.setObject(title, forKey: "title")
        
        // 非同期で保存
        todo.saveInBackgroundWithBlock { (error: NSError!) -> Void in
            if(error == nil){
                println("新規TODOの保存成功。表示の更新などを行う。")
                self.insertNewTodoObject(todo)
            } else {
                println("新規TODOの保存に失敗しました: \(error)")
            }
        }
    }
    
    /// TODOをDataSourceに追加して、表示を更新します
    ///
    /// :param: todo TODOオブジェクト
    /// :returns: None
    func insertNewTodoObject(todo: Todo!) {
        self.objects.insert(todo, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.tableView.reloadData()
    }
}

