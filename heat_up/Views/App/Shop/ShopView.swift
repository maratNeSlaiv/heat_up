//import SwiftUI
//
//struct ShopView: View {
//    @State private var addresses: [String] = UserDefaults.standard.array(forKey: "userAddresses") as? [String] ?? []
//    
//    var body: some View {
//        NavigationStack {
//            VStack {
//                if addresses.isEmpty {
//                    Text("Укажите адрес")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                        .padding()
//                    
//                    NavigationLink(destination: MapView(onAddressSelected: { selectedAddress in
//                        addresses.append(selectedAddress)
//                        UserDefaults.standard.set(addresses, forKey: "userAddresses")
//                    })) {
//                        Text("Добавить адрес")
//                            .font(.body)
//                            .padding()
//                            .background(Color.blue)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                } else {
//                    HStack {
//                        Text("\(addresses.first ?? "")")
//                            .font(.title)
//                            .padding()
//                        Spacer()
//                        Button(action: {
//                            // Здесь вы можете настроить логику перехода, если нужно
//                        }) {
//                            Image(systemName: "chevron.down")
//                                .font(.title)
//                                .foregroundColor(.blue)
//                        }
//                        .padding(.trailing)
//                    }
//                    .padding()
//                    NavigationLink(destination: MapView(onAddressSelected: { selectedAddress in
//                        addresses.append(selectedAddress)
//                        UserDefaults.standard.set(addresses, forKey: "userAddresses")
//                    })) {
//                        Text("Изменить адрес")
//                            .font(.body)
//                            .padding()
//                            .background(Color.orange)
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                    }
//                    .padding()
//                }
//            }
//        }
//    }
//}
//
//struct ShopView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            // Сценарий: список адресов пуст
//            ShopView()
//                .previewDisplayName("Адреса отсутствуют")
//                .onAppear {
//                    UserDefaults.standard.removeObject(forKey: "userAddresses")
//                }
//            
//            // Сценарий: есть адреса
//            ShopView()
//                .previewDisplayName("Адреса существуют")
//                .onAppear {
//                    UserDefaults.standard.set(["Москва, Красная площадь, 1"], forKey: "userAddresses")
//                }
//        }
//    }
//}
