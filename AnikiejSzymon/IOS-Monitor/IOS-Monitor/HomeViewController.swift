//
//  HomeViewController.swift
//  IOS-Monitor
//
//  Created by stud on 12/12/2024.
//
import SwiftUI

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: HomeView(weather: RequestWeather.requestWeatherData(mode: 1)))
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let hostingController = UIHostingController(rootView: HomeView(weather: RequestWeather.requestWeatherData(mode: 1)))
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

struct HomeView: View {
    
    let weather: Dictionary<String, Double>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if UserDefaults.standard.bool(forKey: "temperature") {
                    TemperatureView(value: weather["temperature"]!)
                }
                if UserDefaults.standard.bool(forKey: "clouds") {
                    CloudsView(value: weather["cloudiness"]!)
                }
                
            }
        }
    }
}

struct CloudsView: View {
    let value: Double
    var body: some View {
        if value >= 50.0 {
            VStack(spacing: 1) {
                GifImageView("cloudy")
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 0)

                VStack(alignment: .center, spacing: 0) {
                    Text("It's very cloudy! The cloudiness is at:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    Text("\(String(format: "%.0f", value))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        else {
            VStack(spacing: 1) {
                GifImageView("sunny")
                    .shadow(radius: 5)
                    .frame(width: 200, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .center, spacing: 0) {
                    Text("It's not very cloudy! The cloudiness is at:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                    Text("\(String(format: "%.0f", value))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                }
            }
        }
    }
}

struct TemperatureView: View {
    let value: Double
    var body: some View {
        if value < 10 {
            HStack(alignment: .center, spacing: 5) {
                Image("termometer_cold")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 150)
                    .shadow(radius: 5)
                
                VStack(alignment: .center, spacing: 0) {
                    Text("It's cold today! The temperature is:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                        .multilineTextAlignment(.leading)
                    Text("\(String(format: "%.0f", value))℃")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        else if value > 20 {
            HStack(alignment: .center, spacing: 5) {
                Image("termometer_hot")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 150)
                    .shadow(radius: 5)
                
                VStack(alignment: .center, spacing: 0) {
                    Text("It's warm today! The temperature is:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.leading)
                    Text("\(String(format: "%.0f", value))℃")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.leading)
                }
            }
        }
        else {
            HStack(alignment: .center, spacing: 5) {
//                Image("termometer_warm")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 100, height: 150)
//                    .shadow(radius: 5)
                
                VStack(alignment: .center, spacing: 0) {
                    Text("It's warm today! The temperature is:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                        .multilineTextAlignment(.leading)
                    Text("\(String(format: "%.0f", value))℃")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                        .multilineTextAlignment(.leading)
                }
            }
            
        }
    }
}
