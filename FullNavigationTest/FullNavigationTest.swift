//
//  FullNavigationTest.swift
//  FullNavigationTest
//
//  Created by Pelin Üstünel on 17.04.2025.
//

import XCTest

final class FullNavigationTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    @MainActor
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // 🔸 Welcome ekranında "Sign In" butonuna tıkla
        let signInButton = app.buttons["WelcomeSignIn"]
        XCTAssertTrue(signInButton.waitForExistence(timeout: 5), "Sign In butonu görünmüyor")
        signInButton.tap()
        
        // 🔸 Login ekranında giriş butonuna tıkla (buton identifier'ı SignInClick ise)
        let loginButton = app.buttons["SignIn"]
        XCTAssertTrue(loginButton.waitForExistence(timeout: 5), "Login butonu görünmüyor")
        loginButton.tap()
        
        // 🔹 Ana ekrana gelinmiş mi?
        XCTAssertTrue(app.tabBars.buttons["Home"].exists)
        
        // 🔹 Network sekmesine tıkla
        let networkTab = app.tabBars.buttons["Network"]
        XCTAssertTrue(networkTab.exists, "Network tabı bulunamadı")
        networkTab.tap()
        
        // 🔹 Notification sekmesine tıkla
        let notificationTab = app.tabBars.buttons["Notifications"]
        XCTAssertTrue(notificationTab.exists, "Notificitaions tabı bulunamadı")
        notificationTab.tap()
        
        if app.buttons["chatButton"].exists {
            app.buttons["chatButton"].tap()
        }
        
        let messageCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(messageCell.waitForExistence(timeout: 5), "Mesaj hücresi görünmüyor")
        messageCell.tap()
        
        // 🔹 MessageDetailViewController'daki tableView var mı kontrol et
        let messageDetailTable = app.tables["MessageDetailTable"]
        XCTAssertTrue(messageDetailTable.waitForExistence(timeout: 5), "MessageDetail tableView görünmüyor")
        
        messageDetailTable.swipeDown(velocity: .fast)
        
        // 🔹 Jobs sekmesine tıkla
        let jobTab = app.tabBars.buttons["Jobs"]
        XCTAssertTrue(jobTab.exists, "Jobs tabı bulunamadı")
        jobTab.tap()

        // 🔹 İlk job hücresine tıkla
        let jobCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(jobCell.waitForExistence(timeout: 5), "İlk iş ilanı hücresi görünmüyor")
        jobCell.tap()

        // 🔹 Açılan sheet'in geldiğini kontrol et (JobDetailViewController’ın view’ine accessibilityIdentifier verilmiş olmalı)
        let jobDetailSheet = app.otherElements["JobDetailSheet"]
        XCTAssertTrue(jobDetailSheet.waitForExistence(timeout: 5), "Job detail sheet görünmedi")

        jobDetailSheet.swipeUp()
        
        let start = jobDetailSheet.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        let end = jobDetailSheet.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 1.0))
        start.press(forDuration: 0.2, thenDragTo: end)

        // 🔹 Sheet kapandı mı kontrol et
        XCTAssertFalse(jobDetailSheet.waitForExistence(timeout: 2), "Sheet hala açık görünüyor")

        
        // 🔹 Post sekmesine tıkla → burada özel bir ekran açılacak
        let postTab = app.tabBars.buttons["Post"]
        XCTAssertTrue(postTab.exists, "Post tabı bulunamadı")
        postTab.tap()
        
        // 🔹 Post ekranındaki TextView kontrolü
        let postTextView = app.textViews["PostTextView"]
        let exists = postTextView.waitForExistence(timeout: 5)
        XCTAssertTrue(exists, "Post ekranı açılmadı veya PostTextView bulunamadı")
        
        // 🔹 Exit'e tıklanır (butona identifier verdiğini varsayıyorum)
        if app.buttons["Exit"].exists {
            app.buttons["Exit"].tap()
        }
        
        // 🔹 Home sekmesine dönüldü mü kontrol et
        XCTAssertTrue(app.tabBars.buttons["Home"].isSelected)
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
