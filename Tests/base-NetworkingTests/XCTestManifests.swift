import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(base_NetworkingTests.allTests),
    ]
}
#endif
