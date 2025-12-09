//
//  AccountCellView.swift
//  Instagram-like-trainee
//
//  Created by  on 3.12.25.
//

import SwiftUI

struct AccountCellView: View {
    var body: some View {
        HStack{
            Image(systemName: "person.circle.fill")
            VStack(alignment: .leading){
                Text("Account center")
                    .font(.headline)
                Text("Password & security")
                    .font(.caption)
            }
        }
    }
}

#Preview {
    AccountCellView()
}
