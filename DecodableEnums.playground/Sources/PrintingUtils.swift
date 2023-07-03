var scenarioIndex = 0

public func run(scenario: String, _ execute: () -> Void) {
    scenarioIndex += 1
    print("-----------------------------------------------------------------")
    print("Scenario \(scenarioIndex): \(scenario)")
    print("-----------------------------------------------------------------")
    execute()
    print("-----------------------------------------------------------------\n\n")
}
