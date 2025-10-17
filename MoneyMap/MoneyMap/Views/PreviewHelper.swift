//
//  PreviewHelper.swift
//  MoneyMap
//
//  Created by user279040 on 10/16/25.
//

import Foundation

#if DEBUG
var isPreview: Bool {
    ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
}
#endif
