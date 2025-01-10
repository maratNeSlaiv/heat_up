//
//  DropDownMeny.swift
//  heat_up
//
//  Created by marat orozaliev on 27/12/2024.
//

import SwiftUI

struct DropDownMenu: View {
    
    let options: [String]
    
    var menuWidth: CGFloat  =  150
    var buttonHeight: CGFloat  =  50
    var maxItemDisplayed: Int  =  3
    
    @Binding  var selectedOptionIndex: Int
    @Binding  var showDropdown: Bool
    
    @State private var scrollPosition: Int?
    @State private var searchText: String = ""
    
    var filteredOptions: [String] {
        if searchText.isEmpty {
            return options
        } else {
            return options.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            
            VStack(spacing: 0) {
                // selected item
                Button(action: {
                    withAnimation {
                        showDropdown.toggle()
                    }
                }, label: {
                    HStack(spacing: nil) {
                        Text(options[selectedOptionIndex])
                        Spacer()
                        Image(systemName: "chevron.down")
                            .rotationEffect(.degrees((showDropdown ?  -180 : 0)))
                    }
                })
                .padding(.horizontal, 20)
                .frame(width: menuWidth, height: buttonHeight, alignment: .leading)
                
                // selection menu
                if (showDropdown) {
                    let scrollViewHeight: CGFloat  = filteredOptions.count > maxItemDisplayed ? (buttonHeight*CGFloat(maxItemDisplayed)) : (buttonHeight*CGFloat(filteredOptions.count))
                    VStack(spacing: 0) {
                        // Search bar
                        TextField("Search...", text: $searchText)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 1))
                            .padding(.horizontal, 10)
                        
                        // Filtered options
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(filteredOptions.indices, id: \.self) { index in
                                    Button(action: {
                                        withAnimation {
                                            selectedOptionIndex = options.firstIndex(of: filteredOptions[index]) ?? 0
                                            showDropdown.toggle()
                                        }
                                    }, label: {
                                        HStack {
                                            Text(filteredOptions[index])
                                            Spacer()
                                            if options[selectedOptionIndex] == filteredOptions[index] {
                                                Image(systemName: "checkmark.circle.fill")
                                            }
                                        }
                                    })
                                    .padding(.horizontal, 20)
                                    .frame(width: menuWidth, height: buttonHeight, alignment: .leading)
                                }
                            }
                            .scrollTargetLayout()
                        }
                        .scrollPosition(id: $scrollPosition)
                        .scrollDisabled(filteredOptions.count <= 3)
                        .frame(height: scrollViewHeight)
                        .onAppear {
                            scrollPosition = selectedOptionIndex
                        }
                    }
                    .frame(width: menuWidth)
                }
                
            }
            .foregroundStyle(Color.white)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color(red: 0.0, green: 0.6, blue: 0.4)))
            
        }
        .frame(width: menuWidth, height: buttonHeight, alignment: .top)
        .zIndex(100)
    }
}
