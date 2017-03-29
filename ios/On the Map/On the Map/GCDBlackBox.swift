//
//  GCDBlackBox.swift
//  On the Map
//
//  Created by linlinno on 2017/3/21.
//  Copyright © 2017年 linlinno. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
