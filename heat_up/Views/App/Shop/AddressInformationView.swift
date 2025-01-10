import SwiftUI

struct AddressInformationView: View {
    @Binding var addressInfo: AddressInformation
    @State private var isEditing = false
    @Binding var addressList: [AddressInformation] // Binding to the list of addresses
    
    var body: some View {
        HStack {
            // Иконка в зависимости от типа здания
            Image(systemName: iconForBuildingType(addressInfo.buildingType))
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading)
            
            // Информация о адресе
            VStack(alignment: .leading) {
                Text(addressInfo.address)
                    .font(.system(size: 14))
                    .lineLimit(1)  // Образ текст с троеточием
                    .truncationMode(.tail)
                
                Text("Этаж: \(addressInfo.floor) | Номер двери: \(addressInfo.doorNumber)")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10)
            
            Spacer()
            
            // Кнопка для редактирования
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isEditing.toggle()
                }
            }) {
                Image(systemName: "pencil.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding(.trailing)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).strokeBorder(Color.gray))
        .sheet(isPresented: $isEditing) {
            // Окно редактирования
            NavigationView {
                AddressInformationEditingView(addressInfo: $addressInfo, addressList: $addressList, isEditing: $isEditing)
                    .navigationBarTitle("Address Information", displayMode: .inline) // Title for the view
                    .navigationBarItems(leading: Button(action: {
                        isEditing.toggle() // Dismiss the sheet when the back button is tapped
                    }) {
                        Image(systemName: "arrow.left") // Back arrow icon
                            .foregroundColor(.blue)
                    })
                    .transition(.move(edge: .top)) // Add top-to-bottom transition
            }
        }
    }
    
    // Function to get icon for building type
    func iconForBuildingType(_ type: BuildingType) -> String {
        switch type {
        case .house:
            return "house.fill" // Icon for house
        case .apartment:
            return "building" // Icon for apartment
        case .office:
            return "briefcase" // Icon for office
        case .other:
            return "bed.double" // Icon for other types
        }
    }
}

struct AddressInformationEditingView: View {
    @Binding var addressInfo: AddressInformation
    @Binding var addressList: [AddressInformation]
    @Binding var isEditing: Bool // Binding to dismiss the sheet
    
    var body: some View {
        VStack {
            TextField("Address", text: $addressInfo.address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Floor", text: $addressInfo.floor)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Door Number", text: $addressInfo.doorNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                saveChanges()
            }) {
                Text("Save Changes")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .transition(.move(edge: .top)) // Ensure the panel also animates when closed
        .animation(.easeInOut(duration: 0.3)) // Smooth transition
    }
    
    private func saveChanges() {
        // Find the index of the address in the address list
        if let index = addressList.firstIndex(where: { $0.id == addressInfo.id }) {
            // Update the corresponding address
            addressList[index] = addressInfo
        }
        
        // Dismiss the sheet
        isEditing.toggle()
    }
}

// 4. Preview
struct AddressInformationView_Previews: PreviewProvider {
    @State static var addressList = [
        AddressInformation(address: "Улица Пушкина, дом 10", floor: "3", doorNumber: "5", buildingName: "Жилой комплекс", additionalInfo: "Есть лифт", buildingType: .apartment),
        AddressInformation(address: "Улица Ленина, дом 15", floor: "4", doorNumber: "2", buildingName: "Офисное здание", additionalInfo: "Нет лифта", buildingType: .office)
    ]
    
    static var previews: some View {
        AddressInformationView(addressInfo: $addressList[0], addressList: $addressList)
            .previewLayout(.sizeThatFits)  // Устанавливаем размер для предварительного просмотра
            .padding()
    }
}
