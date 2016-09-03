//
//  Actions.swift
//  Fiber2D
//
//  Created by Andrey Volodin on 28.08.16.
//  Copyright © 2016 s1ddok. All rights reserved.
//

public protocol Targeted {
    /// -----------------------------------------------------------------------
    /// @name Action Targets
    /// -----------------------------------------------------------------------
    /**
     The "target" is typically the node instance that received the Node.runAction() message.
     The action will modify the target properties. The target will be set with the 'start(with:)' method.
     */
    var target: AnyObject? { get set }
}

// Not all actions support reversing. See individual class references to find out if a certain action does not support reversing.
public protocol Reversable {
    /** @name Reversing an Action */
    /**
     Returns an action that runs in reverse (does the opposite).
     
     @note Not all actions support reversing. See individual action's class references.
     
     @return The reversed action.
     */
    var reversed: Reversable { get }
}

// MARK: Continous
// Protocol that defines time-related properties for an object
/**
 Protocol for actions that (can) have a duration
 */
public protocol Continous {
    /** @name Duration */
    /** Duration of the action in seconds. */
    var duration: Time { get set }
    
    /** @name Elapsed
     *  How many seconds had elapsed since the actions started to run.
     */
    var elapsed: Time { get set }
}

public protocol ActionModel {
    /**
     *  Overridden by subclasses to set up an action before it runs.
     *
     *  @param target Target the action will run on.
     */
    mutating func start(with target: AnyObject?)
    
    /**
     *  Called after the action has finished.
     *  Note:
     *  You should never call this method directly.
     *  In stead use: target.stopAction(:)
     */
    mutating func stop()
    
    /**
     *  Updates the action with normalized value.
     *
     *  For example:
     *  A value of 0.5 indicates that the action is 50% complete.
     *
     *  @param state Normalized action progress.
     */
    mutating func update(state: Float)
}

protocol ActionContainer: ActionModel, Tagged {
    /// -----------------------------------------------------------------------
    /// @name Identifying an Action
    /// -----------------------------------------------------------------------
    /** The action's tag. An identifier of the action. */
    var tag: Int { get set }
    
    /// -----------------------------------------------------------------------
    /// @name Action Methods Implemented by Subclasses
    /// -----------------------------------------------------------------------
    /**
     *  Return YES if the action has finished.
     *
     *  @return Action completion status
     */
    var isDone: Bool { get }
    
    /**
     *  Overridden by subclasses to update the target.
     *  Called every frame with the time delta.
     *
     *  Note:
     *  Do not call this method directly. Actions are automatically stepped when used with [Node runAction:].
     *
     *  @param dt Ellapsed interval since last step.
     */
    mutating func step(dt: Time)
}

// Default implementation
extension ActionModel {
    mutating func start(with target: AnyObject?) {}
    mutating public func stop() {}
    mutating func update(state: Float) {}
}

// MARK: - ActionRepeatForever
/**
 *  Repeats an action indefinitely (until stopped).
 *  To repeat the action for a limited number of times use the ActionRepeat action.
 *
 *  @note This action can not be used within a ActionSequence because it is not an ActionInterval action.
 *  However you can use ActionRepeatForever to repeat a ActionSequence.
 *
struct ActionRepeatForever: Action {
    /**
     *  Overridden by subclasses to update the target.
     *  Called every frame with the time delta.
     *
     *  Note:
     *  Do not call this method directly. Actions are automatically stepped when used with [Node runAction:].
     *
     *  @param dt Ellapsed interval since last step.
     */
    public mutating func step(dt: Time) {
        innerAction.step(dt: dt)
        if innerAction.isDone {
            let diff = innerAction.elapsed - innerAction.duration
            innerAction.start(with: target)
            // to prevent jerk. issue #390, 1247
            innerAction.step(dt: 0.0)
            innerAction.step(dt: diff)
        }
    }

    /// -----------------------------------------------------------------------
    /// @name Identifying an Action
    /// -----------------------------------------------------------------------
    /** The action's tag. An identifier of the action. */
    public var tag: Int = 0

    /// -----------------------------------------------------------------------
    /// @name Action Targets
    /// -----------------------------------------------------------------------
    /**
     The "target" is typically the node instance that received the [Node runAction:] message.
     The action will modify the target properties. The target will be set with the 'startWithTarget' method.
     When the 'stop' method is called, target will be set to nil.
     */
    public var target: AnyObject?

    // purposefully undocumented: user does not need to access inner action
    /* Inner action. */
    var innerAction: ActionFiniteTime
    
    /// -----------------------------------------------------------------------
    /// @name Creating a Repeat Forever Action
    /// -----------------------------------------------------------------------
    /**
     *  Initalizes the repeat forever action.
     *
     *  @param action Action to repeat forever
     *
     *  @return An initialised repeat action object.
     */
    init(action: ActionFiniteTime) {
        innerAction = action
    }
    
    mutating func onStart() {
        innerAction.start(with: target)
    }
    
    mutating func onStop() {
        innerAction.stop()
    }
}
*/