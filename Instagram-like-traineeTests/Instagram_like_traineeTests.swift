//
//  Instagram_like_traineeTests.swift
//  Instagram-like-traineeTests
//
//  Created by  on 26.11.25.
//

import XCTest
@testable import Instagram_like_trainee

final class InstagramLikeTraineeTests: XCTestCase {
    
    var viewModel:HomePageViewModel!
    var homeCoordinator: HomePageCoordinator!
    let jsonServiceMock = JsonServiceMock()
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let navigationViewController = UINavigationController()
        homeCoordinator = HomePageCoordinator(
            rootNavigationController: navigationViewController,
            jsonService: jsonServiceMock
        )
        viewModel = HomePageViewModel(coordinator: homeCoordinator, jsonService: jsonServiceMock)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewModel = nil
        homeCoordinator = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUsersCountEqual2() throws {
       // GIVEN
        let expectation = XCTestExpectation(description: "all users loaded")
        let correctUserCount = jsonServiceMock.usersToReturn.count - 1
        let timeout: TimeInterval = 5
        let interval: TimeInterval = 0.5
        var elapsed: TimeInterval = 0
       // WHEN
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let userCount = self.viewModel.getUsersCount()
            let condition = userCount == correctUserCount
            if condition {
                        expectation.fulfill()
                        timer.invalidate()
                    } else {
                        elapsed += interval
                        if elapsed >= timeout {
                            timer.invalidate()
                        }
                    }
                }
       // THEN
        XCTWaiter().wait(for: [expectation], timeout: 2)
    }
    
    func testPostsCountEqual1() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "all Posts loaded")
        let correctPostsCount = jsonServiceMock.postsToReturn.count
        let timeout: TimeInterval = 5
        let interval: TimeInterval = 0.5
        var elapsed: TimeInterval = 0
        // WHEN
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let condition = self.viewModel.getPostsCount() == correctPostsCount
            if condition {
                        expectation.fulfill()
                        timer.invalidate()
                    } else {
                        elapsed += interval
                        if elapsed >= timeout {
                            timer.invalidate()
                        }
                    }
                }
        // THEN
    XCTWaiter().wait(for: [expectation], timeout: 2)
    }
    
    func testStoriesCountEqual1() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "all Stories loaded")
        let correctStoriesCount = jsonServiceMock.storiesToReturn.count
        let timeout: TimeInterval = 5
        let interval: TimeInterval = 0.5
        var elapsed: TimeInterval = 0
        // WHEN
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let condition = self.viewModel.getStoriesCount() == correctStoriesCount
            if condition {
                        expectation.fulfill()
                        timer.invalidate()
                    } else {
                        elapsed += interval
                        if elapsed >= timeout {
                            timer.invalidate()
                        }
                    }
        }
        // THEN
        XCTWaiter().wait(for: [expectation], timeout: 2)
    }
    
    func testUsersWithStoriesEqual2() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "all users loaded")
        var users = self.jsonServiceMock.usersToReturn
        let _ = users.popLast()
        let correctUsersWithStoriesCount = users.filter({ !$0.stories.isEmpty }).count
        let timeout: TimeInterval = 5
        let interval: TimeInterval = 0.5
        var elapsed: TimeInterval = 0
        // WHEN
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let condition = self.viewModel.getUsersWithStoriesCount() == correctUsersWithStoriesCount
            if condition {
                        expectation.fulfill()
                        timer.invalidate()
                    } else {
                        elapsed += interval
                        if elapsed >= timeout {
                            timer.invalidate()
                        }
                    }
        }
        // THEN
        wait(for: [expectation], timeout: 2)
    }
    func testCurrentUserIsTheLastOne() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "all users loaded")
        let correctCurrentUserName = self.jsonServiceMock.usersToReturn.last?.name
        let timeout: TimeInterval = 5
        let interval: TimeInterval = 0.5
        var elapsed: TimeInterval = 0
        // WHEN
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let condition = self.viewModel.getCurrentUserData()?.name == correctCurrentUserName
            if condition {
                        expectation.fulfill()
                        timer.invalidate()
                    } else {
                        elapsed += interval
                        if elapsed >= timeout {
                            timer.invalidate()
                        }
                    }
            
        }
        //THEN
        XCTWaiter().wait(for: [expectation], timeout: 2)
    }
    func testGetUserDataNameEqual() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "all users loaded")
        let userNameToCompare = jsonServiceMock.usersToReturn.filter{
            $0.id == 1
        }.first?.name
        let timeout: TimeInterval = 5
        let interval: TimeInterval = 0.5
        var elapsed: TimeInterval = 0
        // WHEN
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            let condition = self.viewModel.getUserData(id: 1)?.name == userNameToCompare
            if condition {
                        expectation.fulfill()
                        timer.invalidate()
                    } else {
                        elapsed += interval
                        if elapsed >= timeout {
                            timer.invalidate()
                        }
                    }
            
        }
        // THEN
        XCTWaiter().wait(for: [expectation], timeout: 2)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
