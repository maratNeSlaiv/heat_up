import SwiftUI
import MapKit

struct UserAddressView: View {
    @State private var userAddress: String? = UserDefaults.standard.string(forKey: "userAddress") // Получаем адрес из UserDefaults
    @State private var showAddAddressScreen = false // Показать экран для добавления/изменения адреса
    @State private var addressInput: String = "" // Поле для ввода нового адреса
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173), // начальная позиция (Москва)
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var selectedAddress: String? = nil // Выбранный адрес
    @State private var placemark: MKPlacemark? = nil // Плэйсмарка для выбранного адреса

    var body: some View {
        VStack {
            if let address = userAddress {
                // Если адрес существует, показываем его
                Text("Адрес: \(address)")
                    .font(.title)
                    .padding()

                // Кнопка для изменения адреса
                Button(action: {
                    // Переходим на экран для добавления/изменения адреса
                    addressInput = address // Передаем текущий адрес в поле для ввода
                    showAddAddressScreen.toggle()
                }) {
                    Text("Изменить адрес")
                        .font(.body)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            } else {
                // Если адреса нет, показываем текст с кнопкой
                Text("Пожалуйста, укажите адрес")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()

                Button(action: {
                    // Переходим на экран для добавления адреса
                    showAddAddressScreen.toggle()
                }) {
                    Text("Добавить адрес")
                        .font(.body)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .navigationTitle("Информация о пользователе")
        .sheet(isPresented: $showAddAddressScreen) {
            AddAddressView(region: $region, addressInput: $addressInput, placemark: $placemark, onAddressSelected: { selectedAddress in
                self.userAddress = selectedAddress
                UserDefaults.standard.set(selectedAddress, forKey: "userAddress")
                self.showAddAddressScreen = false
            })
        }
    }
}
struct AddAddressView: View {
    @Binding var region: MKCoordinateRegion
    @Binding var addressInput: String
    @Binding var placemark: MKPlacemark?
    var onAddressSelected: (String) -> Void

    @State private var isUserInteracting = false
    @State private var currentAddress: String = "Поиск адреса..."

    var body: some View {
        ZStack {
            // Карта на весь экран
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true)
                .onChange(of: region.center.latitude) { _ in
                    isUserInteracting = true
                }
                .onChange(of: region.center.longitude) { _ in
                    isUserInteracting = true
                }
                .onAppear {
                    // Начальное обратное геокодирование
                    geocodeCoordinate(coordinate: region.center)
                }
                .edgesIgnoringSafeArea(.all) // Карта занимает весь экран

            // Булавка по центру карты
            VStack {
                Image(systemName: "mappin.circle.fill")
                    .resizable()
                    .foregroundColor(.red)
                    .frame(width: 32, height: 32)
                    .offset(y: -16)
            }

            // Всплывающее меню для ввода и подтверждения адреса
            VStack {
                Spacer()

                VStack {
                    TextField("Введите адрес", text: $addressInput)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Найти адрес") {
                        geocodeAddress(address: addressInput)
                    }
                    .padding()

                    if isUserInteracting {
                        Text("Определение адреса...")
                            .padding()
                    } else {
                        Text("Адрес: \(currentAddress)")
                            .padding()
                    }

                    Button("Выбрать этот адрес") {
                        onAddressSelected(currentAddress)
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .background(Color.white.opacity(0.9))
                .cornerRadius(16)
                .padding()
            }
        }
    }

    // Геокодирование текста адреса
    func geocodeAddress(address: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            if let error = error {
                print("Ошибка геокодирования: \(error.localizedDescription)")
                return
            }

            if let placemark = placemarks?.first {
                self.placemark = MKPlacemark(placemark: placemark)
                self.region.center = placemark.location?.coordinate ?? CLLocationCoordinate2D(latitude: 55.7558, longitude: 37.6173)
            }
        }
    }

    // Обратное геокодирование координат
    func geocodeCoordinate(coordinate: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Ошибка обратного геокодирования: \(error.localizedDescription)")
                self.currentAddress = "Неизвестный адрес"
                return
            }

            if let placemark = placemarks?.first {
                self.placemark = MKPlacemark(placemark: placemark)
                self.currentAddress = placemark.name ?? "Неизвестный адрес"
            }
        }
    }
}


// Структура, которая будет использоваться для аннотации на карте и соответствовать протоколу Identifiable
struct PlacemarkAnnotation: Identifiable {
    var id = UUID() // Каждому аннотации нужен уникальный идентификатор
    var coordinate: CLLocationCoordinate2D
    var title: String?

    init(placemark: MKPlacemark) {
        self.coordinate = placemark.coordinate
        self.title = placemark.title
    }
}

struct UserAddressView_Previews: PreviewProvider {
    static var previews: some View {
        UserAddressView()
    }
}
