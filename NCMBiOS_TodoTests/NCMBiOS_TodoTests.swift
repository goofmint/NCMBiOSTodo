//
//  NCMBiOS_TodoTests.swift
//  NCMBiOS_TodoTests
//
//  Created by naokits on 6/6/15.
//  Copyright (c) 2015 Naoki Tsutsui. All rights reserved.
//

import UIKit
import XCTest

class NCMBiOS_TodoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // セットアップ
        NCMB.setApplicationKey(kNCMBiOSApplicationKey, clientKey: kNCMBiOSClientKey)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

    
    // ------------------------------------------------------------------------
    // MARK: Simple Test for NCMB SDK
    // ------------------------------------------------------------------------

    
    /// Todoの追加テスト
    func testAddTodo() {
        let expectation = expectationWithDescription("")

        let obj = NCMBObject(className: "Todo") as NCMBObject
        obj.setObject("日本語テスト", forKey: "message2")
        obj.saveInBackgroundWithBlock { (error: NSError!) -> Void in
            if(error == nil){
                println("保存成功。表示の更新などを行う。")
            } else {
                println("[SAVE ERROR] \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5.0, handler: { (error: NSError!) -> Void in
            println(error)
            XCTAssertNil(error, "Error")
        })
    }

    /// Todoの一覧を取得（更新日時の降順）
    func testGetAllTodo() {
        let expectation = expectationWithDescription("")
        
        var query = NCMBQuery(className: "Todo")
        query.orderByDescending("updateDate")
        query.findObjectsInBackgroundWithBlock({(NSArray todos, NSError error) in
            if (error == nil) {
                println("登録件数: \(todos.count)")
                for todo in todos {
                    println(todo.objectForKey("title"))
                }
            } else {
                println("Error: \(error)")
            }
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5.0, handler: { (error: NSError!) -> Void in
            println(error)
            XCTAssertNil(error, "Error")
        })
    }

    /// Todoの検索テスト
    func testFindTodo() {
        let expectation = expectationWithDescription("")

        var query = NCMBQuery(className: "Todo")
        query.whereKey("title", equalTo: "何かをする")
        query.findObjectsInBackgroundWithBlock({(NSArray objects, NSError error) in
            if (error == nil) {
                println("登録件数: \(objects.count)")
            } else {
                println("エラー情報: \(error)")
            }
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5.0, handler: { (error: NSError!) -> Void in
            println(error)
            XCTAssertNil(error, "Error")
        })
    }
    
    /// Todoの削除テスト（ここでは、一番古いものを１件削除するものとする）
    /// http://mb.cloud.nifty.com/assets/sdk_doc/ios/doc/html/Classes/NCMBObject.html#//api/name/deleteInBackgroundWithBlock:
    func testDeleteOldestTodo() {
        let expectation = expectationWithDescription("Delete oldest todo")

    }
}
