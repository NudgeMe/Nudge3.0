//
//  InvitationStatus.swift
//  Nudge
//
//  Created by Dephanie Ho on 5/6/17.
//  Copyright © 2017 Dephanie Ho. All rights reserved.
//

import UIKit
import Parse

/* Enum to describe status of the invitation */
enum InvitationStatus: Int {
    case created = 0
    case accepted = 1
    case declined = 2
}
