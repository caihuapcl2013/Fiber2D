//
//  ActionInstant.swift
//  Fiber2D
//
//  Created by Andrey Volodin on 03.09.16.
//  Copyright © 2016 s1ddok. All rights reserved.
//

public struct ActionInstantContainer: ActionContainer {
    
    mutating public func start(with target: AnyObject?) {
        action.start(with: target)
    }
    
    mutating public func step(dt: Time) {
        action.update(state: 1.0)
    }
    
    public var tag: Int = 0
    weak var target: AnyObject? = nil
    public var isDone: Bool {
        return true
    }
        
    var action: ActionModel
    init(action: ActionModel) {
        self.action = action
    }
}

public extension ActionModel {
    public var instantly: ActionInstantContainer {
        return ActionInstantContainer(action: self)
    }
}
    
