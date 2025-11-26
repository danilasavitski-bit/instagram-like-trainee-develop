//
//  Instagram_like_traineeTests.swift
//  Instagram-like-traineeTests
//
//  Created by  on 26.11.25.
//

import XCTest
@testable import Instagram_like_trainee

final class Instagram_like_traineeTests: XCTestCase {
    let navigationViewController = UINavigationController()
    let jsonServiceMock = JsonServiceMock()
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUsersCountEqual2() throws {
        let homeCoordinator = HomePageCoordinator(
            rootNavigationController: navigationViewController,
            jsonService: jsonServiceMock
        )
        let viewModel = HomePageViewModel(coordinator: homeCoordinator, jsonService: jsonServiceMock)
        let expectation = XCTestExpectation(description: "all users loaded")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                XCTAssertEqual(viewModel.getUsersCount(), 2) // последний отваливается как текущий пользователь
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    
    func testPostsCountEqual1() throws {
        let homeCoordinator = HomePageCoordinator(
            rootNavigationController: navigationViewController,
            jsonService: jsonServiceMock
        )
        let viewModel = HomePageViewModel(coordinator: homeCoordinator, jsonService: jsonServiceMock)
        let expectation = XCTestExpectation(description: "all Posts loaded")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            print(viewModel.getPostsCount())
                XCTAssertEqual(viewModel.getPostsCount(), 1)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    
    func testStoriesCountEqual1() throws {
        let homeCoordinator = HomePageCoordinator(
            rootNavigationController: navigationViewController,
            jsonService: jsonServiceMock
        )
        let viewModel = HomePageViewModel(coordinator: homeCoordinator, jsonService: jsonServiceMock)
        let expectation = XCTestExpectation(description: "all Stories loaded")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                XCTAssertEqual(viewModel.getStoriesCount(), 1)
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    
    func testUsersWithStoriesEqual2() throws {
        let homeCoordinator = HomePageCoordinator(
            rootNavigationController: navigationViewController,
            jsonService: jsonServiceMock
        )
        let viewModel = HomePageViewModel(coordinator: homeCoordinator, jsonService: jsonServiceMock)
        let expectation = XCTestExpectation(description: "all users loaded")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                XCTAssertEqual(viewModel.getUsersWithStoriesCount(), 2) // не считаем сторисы у последнего чела потому что он слетает как текущий юзер
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    func testCurrentUserIsTheLastOne() throws {
        let homeCoordinator = HomePageCoordinator(
            rootNavigationController: navigationViewController,
            jsonService: jsonServiceMock
        )
        let viewModel = HomePageViewModel(coordinator: homeCoordinator, jsonService: jsonServiceMock)
        let expectation = XCTestExpectation(description: "all users loaded")
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(viewModel.getCurrentUserData()?.name, self.jsonServiceMock.usersToReturn.last?.name) // не считаем сторисы у последнего чела потому что он слетает как текущий юзер
                expectation.fulfill()
            }
        wait(for: [expectation], timeout: 2)
    }
    func testGetUserDataNameEqual() throws {
        let homeCoordinator = HomePageCoordinator(
            rootNavigationController: navigationViewController,
            jsonService: jsonServiceMock
        )
        let viewModel = HomePageViewModel(coordinator: homeCoordinator, jsonService: jsonServiceMock)
        let expectation = XCTestExpectation(description: "all users loaded")
        let userNameToCompare = jsonServiceMock.usersToReturn.filter{
            $0.id == 1
        }.first?.name
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(viewModel.getUserData(id: 1)?.name, userNameToCompare)
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
