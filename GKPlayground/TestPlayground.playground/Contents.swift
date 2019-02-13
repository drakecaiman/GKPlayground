import Cocoa
import GameplayKit
import PlaygroundSupport
import GKPlayground

// Define some example states
class AllState : GKState {}
class NoneState : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return false
    }
}
class SelfState : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == type(of: self)
    }
}
class OneWayState : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        switch stateClass
        {
        case is NoneState.Type:
            fallthrough
        case is SelfState.Type:
            return true
        default:
            return false
        }
    }
}
class TwoWayState : GKState {}

//class SelfOneWayState : GKState {}

let states = [AllState(),
              NoneState(),
              SelfState()]
//              OneWayState()]

if let view = (states.playgroundDescription as? NSView)
{
    PlaygroundPage.current.liveView = view
}
