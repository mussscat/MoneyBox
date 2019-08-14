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
    
    func test_categoryRemainsAfterAllTestObjectsBeingRemoved() {
        let category = self.categoryPlainObject(name: "Test_cat")
        let currency = self.currencyPlainObject(name: "Test_cur")
        let testObject_1 = self.testEntityPlainObject(category: category, currency: currency)
        
        try! self.storage?.saveSynchronously(objects: [category])
        try! self.storage?.saveSynchronously(objects: [currency])
        try! self.storage?.saveSynchronously(objects: [testObject_1])
        
        let expectation = XCTestExpectation(description: "test expectation")
        
        self.storage?.remove(objects: [testObject_1], completion: { result in
            do {
                _ = try result.get()
                self.storage?.fetch(request: StorageRequest<CategoryPlainObject>(identifier: category.identifier), completion: { result in
                    do {
                        let categories = try result.get()
                        XCTAssertNotNil(categories.first)
                    } catch {
                        XCTFail()
                    }
                    expectation.fulfill()
                })
            } catch {
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_removeAllObjectsWhenCategoryRemoved() {
        let category = self.categoryPlainObject(name: "Test_cat")
        let currency = self.currencyPlainObject(name: "Test_cur")
        let testObject_1 = self.testEntityPlainObject(category: category, currency: currency)
        let testObject_2 = self.testEntityPlainObject(category: category, currency: currency)
        
        try! self.storage?.saveSynchronously(objects: [category])
        try! self.storage?.saveSynchronously(objects: [currency])
        try! self.storage?.saveSynchronously(objects: [testObject_1, testObject_2])
        
        let expectation = XCTestExpectation(description: "test expectation")
        
        self.storage?.remove(objects: [category], completion: { result in
            do {
                _ = try result.get()
                self.storage?.fetch(request: StorageRequest<TestEntityPlainObject>(), completion: { result in
                    do {
                        let objects = try result.get()
                        XCTAssertTrue(objects.isEmpty)
                    } catch {
                        XCTFail()
                    }
                    expectation.fulfill()
                })
            } catch {
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_removeAllCategoryLinkedObjectsWhenCategoryRemoved_notLinkedObjectsMustRemain() {
        let category_1 = self.categoryPlainObject(name: "Test_cat_1")
        let category_2 = self.categoryPlainObject(name: "Test_cat_2")
        let currency = self.currencyPlainObject(name: "Test_cur")
        let testObject_1 = self.testEntityPlainObject(category: category_1, currency: currency)
        let testObject_2 = self.testEntityPlainObject(category: category_1, currency: currency)
        let testObject_3 = self.testEntityPlainObject(category: category_2, currency: currency)
        
        try! self.storage?.saveSynchronously(objects: [category_1, category_2])
        try! self.storage?.saveSynchronously(objects: [currency])
        try! self.storage?.saveSynchronously(objects: [testObject_1, testObject_2, testObject_3])
        
        let expectation = XCTestExpectation(description: "test expectation")
        
        self.storage?.remove(objects: [category_1], completion: { result in
            do {
                _ = try result.get()
                self.storage?.fetch(request: StorageRequest<TestEntityPlainObject>(identifier: testObject_3.identifier), completion: { result in
                    do {
                        let objects = try result.get()
                        XCTAssertNotNil(objects.first)
                    } catch {
                        XCTFail()
                    }
                    expectation.fulfill()
                })
            } catch {
                XCTFail()
            }
        })
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Support methods
    
    private func testEntityPlainObject(identifier: String = UUID().uuidString, category: CategoryPlainObject, currency: CurrencyPlainObject) -> TestEntityPlainObject {
        return TestEntityPlainObject(identifier: identifier,
                                     name: "Test_name",
                                     doubleValue: 1.0,
                                     category: category,
                                     currency: currency)
    }
    
    private func categoryPlainObject(identifier: String = UUID().uuidString, name: String) -> CategoryPlainObject {
        return CategoryPlainObject(identifier: identifier, name: name)
    }
    
    private func currencyPlainObject(identifier: String = UUID().uuidString, name: String) -> CurrencyPlainObject {
        return CurrencyPlainObject(identifier: identifier, name: name)
    }
}
