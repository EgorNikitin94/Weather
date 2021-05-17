//
//  City.swift
//  Weather
//
//  Created by Егор Никитин on 15.05.2021.
//

import Foundation

struct CityData: Decodable {
    let response: Response
}

struct Response: Decodable {
    let geoObjectCollection: GeoObjectCollection
    
    enum CodingKeys: String, CodingKey {
        case geoObjectCollection = "GeoObjectCollection"
    }
}

struct GeoObjectCollection: Decodable {
    let featureMember: [FeatureMember]
}

struct FeatureMember: Decodable {
    let geoObject: GeoObject
    
    enum CodingKeys: String, CodingKey {
        case geoObject = "GeoObject"
    }
}

struct GeoObject: Decodable {
    let metaDataProperty: MetaDataProperty
    let point: Point
    
    enum CodingKeys: String, CodingKey {
        case point = "Point"
        case metaDataProperty
    }
    
    func getCoordinate() -> LocationCoordinate? {
        let stringCoordinate = point.pos
        var latitudeString = ""
        var longitudeString = ""
        
        if let index = stringCoordinate.firstIndex(of: " ") {
            latitudeString = String(stringCoordinate.prefix(upTo: index))
            longitudeString = String(stringCoordinate.suffix(from: index))
        }
        
        longitudeString.removeFirst()

        let latitude = Double(latitudeString)
        let longitude = Double(longitudeString)
        guard let latitudeUnwrapped = latitude, let longitudeUnwrapped = longitude else {
            return nil
        }
        return LocationCoordinate(latitude: longitudeUnwrapped, longitude: latitudeUnwrapped)
    }
}

struct MetaDataProperty: Decodable {
    let geocoderMetaData: GeocoderMetaData
    
    enum CodingKeys: String, CodingKey {
        case geocoderMetaData = "GeocoderMetaData"
    }
}

struct GeocoderMetaData: Decodable {
    let addressDetails: AddressDetails
    
    enum CodingKeys: String, CodingKey {
        case addressDetails = "AddressDetails"
    }
}

struct AddressDetails: Decodable {
    let country: Country
    
    enum CodingKeys: String, CodingKey {
        case country = "Country"
    }
}

struct Country: Decodable {
    let countryName: String
    let administrativeArea: AdministrativeArea?
    
    enum CodingKeys: String, CodingKey {
        case countryName = "CountryName"
        case administrativeArea = "AdministrativeArea"
    }
}

struct AdministrativeArea: Decodable {
    let subAdministrativeArea: SubAdministrativeArea?
    let locality: Locality?
    let administrativeAreaName: String?
    
    enum CodingKeys: String, CodingKey {
        case subAdministrativeArea = "SubAdministrativeArea"
        case administrativeAreaName = "AdministrativeAreaName"
        case locality = "Locality"
    }
}


struct SubAdministrativeArea: Decodable {
    let locality: Locality?
    
    enum CodingKeys: String, CodingKey {
        case locality = "Locality"
    }
}

struct Locality: Decodable {
    let localityName: String?
    
    enum CodingKeys: String, CodingKey {
        case localityName = "LocalityName"
    }
}

struct Point: Decodable {
    let pos: String
}

struct City: Decodable {
    let location: LocationCoordinate
    let fullName: String
}
