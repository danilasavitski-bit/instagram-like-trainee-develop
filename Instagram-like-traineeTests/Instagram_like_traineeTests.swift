//
//  Instagram_like_traineeTests.swift
//  Instagram-like-traineeTests
//
//  Created by  on 26.11.25.
//

import XCTest
@testable import Instagram_like_trainee

final class Instagram_like_traineeTests: XCTestCase {
    
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
       // WHEN
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let userCount = self.viewModel.getUsersCount()
       // THEN
            XCTAssertEqual(userCount, correctUserCount) // последний пользователь отваливается как текущий пользователь
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    
    func testPostsCountEqual1() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "all Posts loaded")
        let correctPostsCount = jsonServiceMock.postsToReturn.count
        // WHEN
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let postsCount = self.viewModel.getPostsCount()
        // THEN
            XCTAssertEqual(postsCount, correctPostsCount)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    
    func testStoriesCountEqual1() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "all Stories loaded")
        let correctStoriesCount = jsonServiceMock.storiesToReturn.count
        // WHEN
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let storiesCount = self.viewModel.getStoriesCount()
        // THEN
            XCTAssertEqual(storiesCount, correctStoriesCount)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    
    func testUsersWithStoriesEqual2() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "all users loaded")
        var users = self.jsonServiceMock.usersToReturn
        users.popLast()
        let correctUsersWithStoriesCount = users.filter({ !$0.stories.isEmpty }).count
        // WHEN
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let usersWithStoriesCount = self.viewModel.getUsersWithStoriesCount()
        // THEN
            XCTAssertEqual(usersWithStoriesCount, correctUsersWithStoriesCount) // не считаем сторисы у последнего чела потому что он слетает как текущий юзер
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    func testCurrentUserIsTheLastOne() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "all users loaded")
        let correctCurrentUserName = self.jsonServiceMock.usersToReturn.last?.name
        // WHEN
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let currentUserName = self.viewModel.getCurrentUserData()?.name
        //THEN
            XCTAssertEqual(currentUserName,correctCurrentUserName) // не считаем сторисы у последнего чела потому что он слетает как текущий юзер
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    func testGetUserDataNameEqual() throws {
        // GIVEN
        let expectation = XCTestExpectation(description: "all users loaded")
        let userNameToCompare = jsonServiceMock.usersToReturn.filter{
            $0.id == 1
        }.first?.name
        // WHEN
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            let userName = self.viewModel.getUserData(id: 1)?.name
        // THEN
            XCTAssertEqual(userName, userNameToCompare)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
