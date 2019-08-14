//
//  StorageBaseTests.swift
//  MBStorageTests
//
//  Created by s.m.fedorov on 13/08/2019.
//  Copyright © 2019 s.m.fedorov. All rights reserved.
//

import XCTest
import CoreData
@testable import MBStorage

class StorageBaseTests: XCTestCase {
    
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
    
    func test_saveOrUpdate_saveObjectInDB() {
        let testObject = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let expectation = XCTestExpectation(description: "test expectation")
        self.storage?.saveOrUpdate(objects: [testObject], completion: { result in
            let request = StorageRequest<TestEntityPlainObject>(identifier: testObject.identifier)
            self.storage?.fetch(request: request, completion: { result in
                do {
                    let values = try result.get()
                    guard let firstValue = values.first else {
                        XCTFail()
                        return
                    }
                    
                    XCTAssertEqual(testObject.identifier, firstValue.identifier)
                    expectation.fulfill()
                } catch {
                    XCTFail()
                }
            })
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_saveOrUpdate_updateSavedObjectInDB() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let testObject_2 = self.testEntityPlainObject(identifier: testObject_1.identifier, name: "Test_2", doubleValue: 2.0)
        let expectation = XCTestExpectation(description: "test expectation")
        self.storage?.saveOrUpdate(objects: [testObject_1]) { result in
            do {
                _ = try result.get()
                self.storage?.saveOrUpdate(objects: [testObject_2]) { innerResult in
                    do {
                        let values = try innerResult.get()
                        guard let value = values.first else {
                            XCTFail()
                            return
                        }
                        
                        XCTAssertEqual(testObject_2.name, value.name)
                        XCTAssertEqual(testObject_2.doubleValue, value.doubleValue)
                        
                        let count = try! self.storage?.count(for: StorageRequest<TestEntityPlainObject>())
                        XCTAssertEqual(count!, 1)
                        
                        expectation.fulfill()
                    } catch {
                        XCTFail()
                    }
                }
            } catch {
                XCTFail()
            }
        }
    }
    
    func test_saveOrUpdate_saveMultipleObjectsWithDifferentIdentifiers() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let testObject_2 = self.testEntityPlainObject(name: "Test_2", doubleValue: 2.0)
        let expectation = XCTestExpectation(description: "test expectation")
        self.storage?.saveOrUpdate(objects: [testObject_1, testObject_2], completion: { result in
            let request = StorageRequest<TestEntityPlainObject>()
            self.storage?.fetch(request: request, completion: { result in
                do {
                    let values = try result.get()
                    XCTAssertEqual(values.count, 2)
                    expectation.fulfill()
                } catch {
                    XCTFail()
                }
            })
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_saveOrUpdate_saveMultipleSameObjects_WillBeSavedOnlyOne() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let testObject_2 = self.testEntityPlainObject(identifier: testObject_1.identifier, name: "Test_1", doubleValue: 1.0)
        let expectation = XCTestExpectation(description: "test expectation")
        self.storage?.saveOrUpdate(objects: [testObject_1, testObject_2], completion: { result in
            let request = StorageRequest<TestEntityPlainObject>()
            self.storage?.fetch(request: request, completion: { result in
                do {
                    let values = try result.get()
                    XCTAssertEqual(values.count, 1)
                    expectation.fulfill()
                } catch {
                    XCTFail()
                }
            })
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_update_updateObjectIfObjectIsInDB_WithSuccess() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let testObject_2 = self.testEntityPlainObject(identifier: testObject_1.identifier, name: "Test_2", doubleValue: 2.0)
        let expectation = XCTestExpectation(description: "test expectation")
        self.storage?.saveOrUpdate(objects: [testObject_1, testObject_2], completion: { result in
            let request = StorageRequest<TestEntityPlainObject>(identifier: testObject_1.identifier)
            self.storage?.fetch(request: request, completion: { result in
                do {
                    let values = try result.get()
                    guard let value = values.first else {
                        XCTFail()
                        return
                    }
                    
                    XCTAssertEqual(value.identifier, testObject_2.identifier)
                    XCTAssertEqual(value.name, testObject_2.name)
                    XCTAssertEqual(value.doubleValue, testObject_2.doubleValue)
                    expectation.fulfill()
                } catch {
                    XCTFail()
                }
            })
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_update_updateObjectIfObjectIsAbscentInDB_WithFailure() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let expectation = XCTestExpectation(description: "test expectation")
        self.storage?.update(objects: [testObject_1], completion: { result in
            do {
                _ = try result.get()
            } catch {
                XCTAssertNotNil(error)
            }
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_removeObjectFromDB_ObjectExists_WithSuccess() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let expectation = XCTestExpectation(description: "test expectation")
        try! self.storage?.saveSynchronously(objects: [testObject_1])
        self.storage?.remove(objects: [testObject_1], completion: { result in
            do {
                _ = try result.get()
                self.storage?.fetch(request: StorageRequest<TestEntityPlainObject>(identifier: testObject_1.identifier), completion: { result in
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
    
    func test_removeObjectFromDB_ObjectNotExists_WithSuccess() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let expectation = XCTestExpectation(description: "test expectation")
        try! self.storage?.saveSynchronously(objects: [testObject_1])
        self.storage?.remove(objects: [testObject_1], completion: { result in
            do {
                _ = try result.get()
            } catch {
                XCTFail()
            }
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetch_existingObjectByIdentifier_WithSuccess() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let testObject_2 = self.testEntityPlainObject(name: "Test_2", doubleValue: 1.0)
        let expectation = XCTestExpectation(description: "test expectation")
        try! self.storage?.saveSynchronously(objects: [testObject_1, testObject_2])
        self.storage?.fetch(request: StorageRequest<TestEntityPlainObject>(identifier: testObject_1.identifier), completion: { result in
            do {
                let objects = try result.get()
                guard let object = objects.first else {
                    XCTFail()
                    return
                }
                
                XCTAssertEqual(testObject_1.identifier, object.identifier)
            } catch {
                XCTFail()
            }
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetch_allObjects_withSuccess() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let testObject_2 = self.testEntityPlainObject(name: "Test_2", doubleValue: 1.0)
        let expectation = XCTestExpectation(description: "test expectation")
        try! self.storage?.saveSynchronously(objects: [testObject_1, testObject_2])
        self.storage?.fetch(request: StorageRequest<TestEntityPlainObject>(), completion: { result in
            do {
                let objects = try result.get()
                XCTAssertEqual(objects.count, 2)
            } catch {
                XCTFail()
            }
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetch_fetchObjectByIdentifierIfNotSaved_EmptyResultWithSuccess() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let expectation = XCTestExpectation(description: "test expectation")
        self.storage?.fetch(request: StorageRequest<TestEntityPlainObject>(identifier: testObject_1.identifier), completion: { result in
            do {
                let objects = try result.get()
                XCTAssertTrue(objects.isEmpty)
            } catch {
                XCTFail()
            }
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_fetch_fetchObjectsIfNotSaved_EmptyResultWithSuccess() {
        let expectation = XCTestExpectation(description: "test expectation")
        self.storage?.fetch(request: StorageRequest<TestEntityPlainObject>(), completion: { result in
            do {
                let objects = try result.get()
                XCTAssertTrue(objects.isEmpty)
            } catch {
                XCTFail()
            }
            
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_count_thereAreSavedObjects_WithSuccess() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        try! self.storage?.saveSynchronously(objects: [testObject_1])
        do {
            let count = try self.storage?.count(for: StorageRequest<TestEntityPlainObject>())
            XCTAssertEqual(count, 1)
        } catch {
            XCTFail()
        }
    }
    
    func test_count_thereAreNoObjects_WithSuccess() {
        do {
            let count = try self.storage?.count(for: StorageRequest<TestEntityPlainObject>())
            XCTAssertEqual(count, 0)
        } catch {
            XCTFail()
        }
    }
    
    func test_save_objectIsNotInDB_WithSuccess() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let expectation = XCTestExpectation(description: "test expectation")
        self.storage?.save(objects: [testObject_1], completion: { _ in
            self.storage?.fetch(request: StorageRequest<TestEntityPlainObject>(identifier: testObject_1.identifier), completion: { result in
                do {
                    let objects = try result.get()
                    XCTAssertNotNil(objects.first)
                } catch {
                    XCTFail()
                }
                
                expectation.fulfill()
            })
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_save_objectInInDB_shouldNotSaveDouble_WithSuccess() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let testObject_2 = self.testEntityPlainObject(identifier: testObject_1.identifier, name: "Test_2", doubleValue: 2.0)
        let expectation = XCTestExpectation(description: "test expectation")
        try! self.storage?.saveSynchronously(objects: [testObject_1])
        self.storage?.save(objects: [testObject_2], completion: { _ in
            self.storage?.fetch(request: StorageRequest<TestEntityPlainObject>(), completion: { result in
                do {
                    let objects = try result.get()
                    XCTAssertEqual(objects.count, 1)
                } catch {
                    XCTFail()
                }
                
                expectation.fulfill()
            })
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_save_objectInInDB_shouldNotUpdate_WithSuccess() {
        let testObject_1 = self.testEntityPlainObject(name: "Test_1", doubleValue: 1.0)
        let testObject_2 = self.testEntityPlainObject(identifier: testObject_1.identifier, name: "Test_2", doubleValue: 2.0)
        let expectation = XCTestExpectation(description: "test expectation")
        try! self.storage?.saveSynchronously(objects: [testObject_1])
        self.storage?.save(objects: [testObject_2], completion: { _ in
            self.storage?.fetch(request: StorageRequest<TestEntityPlainObject>(identifier: testObject_2.identifier), completion: { result in
                do {
                    let objects = try result.get()
                    guard let object = objects.first else {
                        XCTFail()
                        return
                    }
                    
                    XCTAssertEqual(object.name, testObject_1.name)
                    XCTAssertEqual(object.doubleValue, testObject_1.doubleValue)
                } catch {
                    XCTFail()
                }
                
                expectation.fulfill()
            })
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - Support methods
    
    private func testEntityPlainObject(identifier: String = UUID().uuidString, name: String, doubleValue: Double) -> TestEntityPlainObject {
        let category = self.categoryPlainObject(name: "Test_1")
        let currency = self.currencyPlainObject(name: "Test_1")
        return TestEntityPlainObject(identifier: identifier,
                                     name: name,
                                     doubleValue: doubleValue,
                                     category: category.identifier,
                                     currency: currency.identifier)
    }
    
    private func testEntityPlainObject(identifier: String = UUID().uuidString, name: String, doubleValue: Double, category: CategoryPlainObject) -> TestEntityPlainObject {
        let currency = self.currencyPlainObject(name: "Test_1")
        return TestEntityPlainObject(identifier: identifier,
                                     name: name,
                                     doubleValue: doubleValue,
                                     category: category.identifier,
                                     currency: currency.identifier)
    }
    
    private func testEntityPlainObject(identifier: String = UUID().uuidString, name: String, doubleValue: Double, currency: CurrencyPlainObject) -> TestEntityPlainObject {
        let category = self.categoryPlainObject(name: "Test_1")
        return TestEntityPlainObject(identifier: identifier,
                                     name: name,
                                     doubleValue: doubleValue,
                                     category: category.identifier,
                                     currency: currency.identifier)
    }
    
    private func categoryPlainObject(identifier: String = UUID().uuidString, name: String) -> CategoryPlainObject {
        return CategoryPlainObject(identifier: identifier, name: name)
    }
    
    private func currencyPlainObject(identifier: String = UUID().uuidString, name: String) -> CurrencyPlainObject {
        return CurrencyPlainObject(identifier: identifier, name: name)
    }
}
