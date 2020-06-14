//
//  Activity.swift
//  emoteen
//
//  Created by Douglas Purdy on 6/13/20.
//  Copyright © 2020 Lana. All rights reserved.
//

import SwiftUI

struct ActivityView: View {
    var body: some View {
        VStack {
            Image(systemName: "person")
            Text("Activity")
        }
    }
}

struct Activity_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
