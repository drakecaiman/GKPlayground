import Cocoa
import GameplayKit
import PlaygroundSupport
import GKPlayground

// Define some example states
class Loop1State : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == Loop2State.self
    }
    
}
class Loop2State : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == Loop3State.self
    }
    
}
class Loop3State : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == Loop1State.self
    }
    
}
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
class OutState : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == InState.self
    }
}
class InState : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return false
    }
}
class MultipleOutState : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        switch stateClass
        {
        case is Out1State.Type:
            fallthrough
        case is Out2State.Type:
            fallthrough
        case is Out3State.Type:
            return true
        default:
            return false
        }
    }
}
class Out1State : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return false
    }
}
class Out2State : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return false
    }
}
class Out3State : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return false
    }
}
class MultipleInState : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return false
    }
}
class In1State : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == MultipleInState.self
    }
}
class In2State : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == MultipleInState.self
    }
}
class In3State : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return stateClass == MultipleInState.self
    }
}

class TestingForAStateWithALongNameState : GKState
{
    override func isValidNextState(_ stateClass: AnyClass) -> Bool
    {
        return false
    }
}

let states = [TestingForAStateWithALongNameState(),
              Loop1State(),
              Loop2State(),
              Loop3State(),
              NoneState(),
              SelfState(),
              OutState(),
              InState(),
              In1State(),
              In2State(),
              In3State(),
              MultipleInState(),
              MultipleOutState(),
              Out1State(),
              Out2State(),
              Out3State()]

if let view = (states.playgroundDescription as? NSView)
{
    PlaygroundPage.current.liveView = view
}
