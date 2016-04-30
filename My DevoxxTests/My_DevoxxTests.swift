//
//  My_DevoxxTests.swift
//  My DevoxxTests
//
//  Created by Maxime on 30/04/16.
//  Copyright © 2016 maximedavid. All rights reserved.
//

import XCTest
@testable import My_Devoxx
import PromiseKit
import CoreData

class My_DevoxxTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoadCache_empty() {
        class FakeViewController : ViewController {
            override func getService() -> CfpService {
                return FakeCfpService()
            }
            override func initCfp() -> Promise<[Cfp]> {
                return Promise{ fulfill, reject in
                    fulfill([Cfp]())
                }
            }
        }
        
        class FakeCfpService : CfpService {
            override func fetchCfps() -> Promise<[Cfp]> {
                return Promise{ fulfill, reject in
                    fulfill([Cfp]())
                }
            }
        }

        let expectation = expectationWithDescription("emptyCfpArray")
        let vc = FakeViewController()
        vc.loadCache().then { (cfps : [Cfp]) -> Void in
            XCTAssertEqual(0, cfps.count)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10.0, handler:nil)
    }

    func testLoadCache_notEmpty() {
        class FakeViewController : ViewController {
            override func getService() -> CfpService {
                return FakeCfpService()
            }
        }
    
        class FakeCfpService : CfpService {
            
            func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
                let managedObjectModel = NSManagedObjectModel.mergedModelFromBundles([NSBundle.mainBundle()])!
                
                let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
                
                do {
                    try persistentStoreCoordinator.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
                } catch {
                    print("Adding in-memory persistent store failed")
                }
                
                let managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
                managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
                
                return managedObjectContext
            }

            
            override func fetchCfps() -> Promise<[Cfp]> {
                return Promise{ fulfill, reject in
                    let dummyCfp = Cfp(context : self.setUpInMemoryManagedObjectContext())
                    fulfill([dummyCfp, dummyCfp, dummyCfp])
                }
            }
        }
        
        let expectation = expectationWithDescription("emptyCfpArray")
        let vc = FakeViewController()
        vc.loadCache().then { (cfps : [Cfp]) -> Void in
            XCTAssertEqual(3, cfps.count)
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10.0, handler:nil)
    }


    
}
