//
//  ContentView.swift
//  PagingSample
//
//  Created by cranoo on 2025/05/19.
//

import SwiftUI

struct ContentView: View {
    @State private var vm = ContentViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(vm.listItem) { item in
                    ListRow(item: item)
                }
                
                Color.clear
                    .onAppear {
                        vm.appendListItem()
                    }
            }
        }
        .overlay {
            if vm.isFetching {
                ProgressView()
            }
        }
    }
}

struct ListRow: View {
    let item: ListItem
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("\(item.age)")
                    .foregroundStyle(.gray)
                
                Spacer()
            }
            
            Text("ID: \(item.id.uuidString)")
                .font(.caption)
                .foregroundStyle(.gray)
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .compositingGroup()
        .shadow(radius: 5)
        .padding()
    }
}

@Observable
final class ContentViewModel {
    var isFetching = false
    var listItem: [ListItem] = []
    
    func appendListItem() {
        guard isFetching != true else {
            print("Return because isFetching is true")
            return
        }
        
        Task {
            isFetching = true
            print("Starting task......")
            try await Task.sleep(for: .seconds(3))
            let currentAge = listItem.last?.age ?? 0
            for i in 0..<50 {
                listItem.append(.init(name: "your-name: \(i)", age: i + currentAge + 1))
            }
            isFetching = false
        }
    }
}

struct ListItem: Identifiable {
    let id = UUID()
    let name: String
    let age: Int
}


#Preview {
    ContentView()
}

#Preview("ListRow") {
    let item = ListItem(name: "test", age: 10)
    ListRow(item: item)
}
