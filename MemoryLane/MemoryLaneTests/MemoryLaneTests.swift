//
//  MemoryLaneTests.swift
//  MemoryLaneTests
//
//  Created by Cindy Chen on 10/31/23.
//

import XCTest
@testable import MemoryLane
import FirebaseFirestore

final class MemoryLaneTests: XCTestCase {

    func testIsEmail() throws {
        XCTAssert(Helpers.isEmail("cindy@gmail.com"))
        
        let str = "als@jdhkfjsahlfkdjhkahsldkjhfaskldhfkahsdlfhasdfhasljdkhflajsdhflasjdfhlashdflaksjhdflahsdfljdakshfjkhalsdj"
        XCTAssert(str.count > 100)
        XCTAssertFalse(Helpers.isEmail(str))
        XCTAssertFalse(Helpers.isEmail("asdkfhskljdf"))
    }
    
    func testFormattedTime() throws{
        var components = DateComponents()
        components.year = 2023
        components.month = 12
        components.day = 11
        components.hour = 7
        components.minute = 45
        let calendar = Calendar.current
        let date = calendar.date(from: components)!
        let res = Helpers.formattedTime(time: Timestamp(date: date))
        
        XCTAssert(res == "Dec 11, 2023 07:45")
    }
    
    func testGetDate() throws{
        var components = DateComponents()
        components.year = 2023
        components.month = 12
        components.day = 11
        components.hour = 7
        components.minute = 45
        let calendar = Calendar.current
        let date = calendar.date(from: components)!
        let res = Helpers.getDate(Timestamp(date: date))
        print(res)
        XCTAssert(res == "Dec 11, 2023 at 07:45:00")
    }
    
    func testGetYear() throws{
        var components = DateComponents()
        components.year = 2023
        let calendar = Calendar.current
        let date = calendar.date(from: components)!
        let res = Helpers.getYear(Timestamp(date: date))
        XCTAssert(res == 2023)
    }
    
    func testValidateRegistration() throws{
        XCTAssert(Helpers.validateRegistration("cindy", "123456", "123456") == nil)
        XCTAssert(Helpers.validateRegistration("", "123456", "123456") == "Username can not be blank")
        XCTAssert(Helpers.validateRegistration("cindy", "", "123456") == "Password can not be blank")
        XCTAssert(Helpers.validateRegistration("cindy", "123456", "") == "Password Confirmation can not be blank")
        XCTAssert(Helpers.validateRegistration("cindy", "1234567", "123456") == "Passwords don't match")
        XCTAssert(Helpers.validateRegistration("cindy", "123", "123") == "Password must be > 6 characters")
    }
}
