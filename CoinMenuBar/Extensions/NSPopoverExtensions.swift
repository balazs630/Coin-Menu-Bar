//
//  NSPopoverExtensions.swift
//  Coin Menu Bar
//
//  Created by Horváth Balázs on 2018. 05. 01..
//  Copyright © 2018. Horváth Balázs. All rights reserved.
//

import Cocoa

public extension NSPopover {
    func performOpen (statusItem: NSStatusItem) {
        if let button = statusItem.button {
            self.show(relativeTo: button.bounds,
                         of: button,
                         preferredEdge: .minY)
        }
    }

}
