import SwiftUI

struct UserProfileView: View {
    @StateObject var viewModel = UserProfileViewModel()
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let profile = viewModel.userProfile {
                Form {
                    Section(header: Text("Basic Information")) {
                        ProfileField(title: "Name", value: profile.name)
                        ProfileField(title: "Profile Picture", value: profile.profilePicture ?? "No picture")
                        ProfileField(title: "Date of Birth", value: profile.dateOfBirth)
                        ProfileField(title: "Gender", value: profile.gender)
                        ProfileField(title: "Location", value: profile.location)
                    }
                    
                    Section(header: Text("Physical Information")) {
                        ProfileField(title: "Height", value: profile.height.map { "\($0) cm" })
                        ProfileField(title: "Weight", value: profile.weight.map { "\($0) kg" })
                        ProfileField(title: "Body Fat Percentage", value: profile.bodyFatPercentage.map { "\($0)%" })
                        ProfileField(title: "Body Type", value: profile.bodyType)
                        ProfileField(title: "BMI", value: profile.bmi.map { "\($0)" })
                    }
                    
                    Section(header: Text("Goals & Preferences")) {
                        ProfileField(title: "Goal", value: profile.goalType)
                        ProfileField(title: "Target Weight", value: profile.targetWeight.map { "\($0) kg" })
                        ProfileField(title: "Daily Calories", value: profile.dailyCalories.map { "\($0) kcal" })
                        ProfileField(title: "Activity Level", value: profile.activityLevel)
                        ProfileField(title: "Preferred Workouts", value: profile.preferredWorkouts?.joined(separator: ", "))
                        ProfileField(title: "Workout Time Preference", value: profile.workoutTimePreference)
                        ProfileField(title: "Experience Level", value: profile.experienceLevel)
                    }
                }
            } else if viewModel.hasError {
                VStack {
                    Text("Failed to load profile")
                    Button(action: {
                        viewModel.reloadProfile()
                    }) {
                        Text("Try Again")
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadUserProfile()
        }
    }
}

struct ProfileField: View {
    var title: String
    var value: String?
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            if let value = value {
                Text(value)
                    .foregroundColor(.gray)
            } else {
                Text("Not Provided")
                    .foregroundColor(.red)
            }
        }
    }
}

class UserProfileViewModelPreview: UserProfileViewModel {
    override init() {
        super.init()
        // Здесь создаем фиктивные данные для предварительного просмотра
        self.userProfile = UserProfile(
            id: "123",
            name: "John Doe",
            profilePicture: "https://example.com/profile.jpg",
            dateOfBirth: "1990-01-01",
            gender: "Male",
            location: "New York",
            height: 180,
            weight: 75,
            bodyFatPercentage: 15.0,
            bodyType: "Mesomorph",
            bmi: 23.1,
            goalType: "Weight Loss",
            targetWeight: 70,
            dailyCalories: 2000,
            activityLevel: "Moderate",
            preferredWorkouts: ["Cardio", "Strength Training"],
            workoutTimePreference: "Morning",
            experienceLevel: "Intermediate"
        )
        self.isLoading = false
        self.hasError = false
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            UserProfileView(viewModel: UserProfileViewModelPreview())
                .previewDevice("iPhone 14")
        }
    }
}
