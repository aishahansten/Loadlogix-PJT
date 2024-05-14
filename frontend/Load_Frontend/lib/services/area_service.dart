import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/building_data.dart';

class AreaService {
  Future<List<BuildingData>> getBuildingPriority(String accessToken) async {
    final response = await http.get(
        Uri.parse('http://43.201.116.59:8081/api/area'),
        headers: {
          "Authorization": "Bearer $accessToken"
        }
    );

    if (response.statusCode == 200) {
      List<BuildingData> buildings = [];
      var data = json.decode(response.body);
      for (var i in data['result']) {
        BuildingData buildingData = BuildingData.fromJson(i);
        buildings.add(BuildingData(
          buildingId: buildingData.buildingId,
          buildingName: buildingData.buildingName,
          totalGoods: buildingData.totalGoods,
          latitude: buildingData.latitude,
          longitude: buildingData.longitude,
        ));
      }
      return buildings;
    } else {
      return [];
    }
  }
}