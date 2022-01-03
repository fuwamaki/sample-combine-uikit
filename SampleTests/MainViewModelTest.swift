//
//  MainViewModelTest.swift
//  SampleTests
//
//  Created by fuwamaki on 2022/01/03.
//

import XCTest
@testable import Sample

class MainViewModelTest: XCTestCase {

    func testFetchWithSuccess() async throws {
        let mockAPIClient: APIClientable = MockAPIClient(isSuccess: true)
        let viewModel = MainViewModel(apiClient: mockAPIClient)
        await viewModel.fetch(query: "test")
        XCTAssertEqual(viewModel.listSubject.value.count, 1)
    }

    func testFetchWithFailure() async throws {
        let mockAPIClient: APIClientable = MockAPIClient(isSuccess: false)
        let viewModel = MainViewModel(apiClient: mockAPIClient)
        await viewModel.fetch(query: "test")
        XCTAssertEqual(viewModel.listSubject.value.count, 0)
    }

    func testHandleDidSelectRowAt() async throws {
        let mockAPIClient: APIClientable = MockAPIClient(isSuccess: true)
        let viewModel = MainViewModel(apiClient: mockAPIClient)
        await viewModel.fetch(query: "test")
        viewModel.handleDidSelectRowAt(IndexPath(row: 0, section: 0))
    }
}
