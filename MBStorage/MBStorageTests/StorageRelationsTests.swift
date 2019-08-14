//
//  StorageRelationsTests.swift
//  MBStorageTests
//
//  Created by s.m.fedorov on 14/08/2019.
//  Copyright © 2019 s.m.fedorov. All rights reserved.
//

import XCTest
import CoreData
@testable import MBStorage

class StorageRelationsTests: XCTestCase {

    private var storage: IStorage?
    
    override func setUp() {
        let bundle = Bundle(for: StorageBaseTests.self)
        let stack = CoreDataStack(dbName: "MBTestModel", bundle: bundle, storeType: NSInMemoryStoreType)
        let expectation = XCTestExpectation(description: "stack setup")
        stack.setupStack { result in
            do {
                _ = try result.get()
            } catch {
                XCTFail()
            }
            
            expectation.fulfill()
        }
        
        self.storage = Storage(coreDataStack: stack)
        wait(for: [expectation], timeout: 5.0)
    }
}
