//
//  MainViewModelTest.swift
//  SampleTests
//
//  Created by fuwamaki on 2022/01/03.
//

import XCTest
import Combine
@testable import Sample

class MainViewModelTest: XCTestCase {

    private var subscriptions = Set<AnyCancellable>()

    func testFetchWithSuccess() async throws {
        let mockAPIClient: APIClientable = MockAPIClient(isSuccess: true)
        let viewModel = MainViewModel(apiClient: mockAPIClient)
        var isLoading: Bool = true
        viewModel.isLoadingSubject
            .sink {
                XCTAssertEqual($0, isLoading)
                isLoading.toggle()
            }
            .store(in: &subscriptions)
        await viewModel.fetch(query: "test")
        XCTAssertEqual(viewModel.listSubject.value.count, 1)
    }

    func testFetchWithFailure() async throws {
        let mockAPIClient: APIClientable = MockAPIClient(isSuccess: false)
        let viewModel = MainViewModel(apiClient: mockAPIClient)
        var isLoading: Bool = true
        viewModel.isLoadingSubject
            .sink {
                XCTAssertEqual($0, isLoading)
                isLoading.toggle()
            }
            .store(in: &subscriptions)
        viewModel.errorAlertSubject
            .sink { XCTAssertNotNil($0) }
            .store(in: &subscriptions)
        await viewModel.fetch(query: "test")
        XCTAssertEqual(viewModel.listSubject.value.count, 0)
    }

    func testHandleDidSelectRowAt() async throws {
        let mockAPIClient: APIClientable = MockAPIClient(isSuccess: true)
        let viewModel = MainViewModel(apiClient: mockAPIClient)
        viewModel.showWebViewSubject
            .sink { XCTAssertNotNil($0) }
            .store(in: &subscriptions)
        await viewModel.fetch(query: "test")
        viewModel.handleDidSelectRowAt(IndexPath(row: 0, section: 0))
    }
}
