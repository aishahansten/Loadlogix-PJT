import 'dart:convert';
import 'dart:math';

import 'package:load_frontend/models/good_data.dart';
import 'package:http/http.dart' as http;
import 'package:load_frontend/views/box_simulation/box.dart';

import '../models/vector3.dart';
import 'base_url.dart';

bool isDebug = true;

class GoodsService {
  Future<List<GoodsData>> getGoods(String accessToken) async {
    if (isDebug) {
      List<GoodsData> goods = [];
      Random random = Random();


      //three.Vector3 truckSize = three.Vector3(280 * gScale , 160 * gScale, 160 * gScale);

      int goodsId = 0;
      for (int x = 0; x < 6; x++) {
        for (int y = 0; y < 6; y++) {
          for (int z = 0; z < 6; z++) {
            String type = 'L${random.nextInt(6) + 1}';  // Random type between S1 and S6

            goods.add(GoodsData(
                goodsId: goodsId,
                type: type,
                position: Vector3(x.toDouble() * 280 / 6.0 * gScale, y.toDouble()* 160 / 6.0* gScale, z.toDouble()* 160 / 6.0* gScale),
                //position: Vector3(x.toDouble(), y as double, z as double),

                weight: random.nextInt(1000),
                buildingId: random.nextInt(5),
                buildingName: 'Building Name ${goodsId++}',
                detailAddress: '서울시 강남구 삼성동 123-456'));
          }
        }
      }
      print("goods : $goods");
      return goods;
    }

    final response = await http.get(Uri.parse('http://192.168.31.245:8081/api/goods/loads'), headers: {"Authorization":  "Bearer $accessToken"});
    if (response.statusCode == 200) {
      List<GoodsData> goods = [];
      var data = json.decode(response.body);
      print("data: $data");
      Random random = Random();
      for (var i in data['result']['goods']) {
        GoodsData goodsData = GoodsData.fromJson(i);
        goods.add(GoodsData(
            goodsId: goodsData.goodsId,
            type: goodsData.type,
            position: Vector3(
                goodsData.position.x.toDouble() * gScale,//* 280 / 6.0 * gScale,
                goodsData.position.z.toDouble() * gScale,//* 160 / 6.0 * gScale,
                goodsData.position.y.toDouble() * gScale),//* 160 / 6.0 * gScale),
            //position: Vector3(x.toDouble(), y as double, z as double),

            weight: goodsData.weight,
            buildingId: goodsData.buildingId,
            buildingName: goodsData.buildingName,
            detailAddress: goodsData.detailAddress));
      }

        //goods.add(GoodsData.fromJson(i));


      // Random random = Random();
      // int goodsId = 0;
      // for (int x = 0; x < 6; x++) {
      //   for (int y = 0; y < 6; y++) {
      //     for (int z = 0; z < 6; z++) {
      //       String type = 'L${random.nextInt(6) + 1}';  // Random type between S1 and S6
      //
      //       goods.add(GoodsData(
      //           goodsId: goodsId,
      //           type: type,
      //           position: Vector3(x.toDouble() * 280 / 6.0 * gScale, y.toDouble()* 160 / 6.0* gScale, z.toDouble()* 160 / 6.0* gScale),
      //           //position: Vector3(x.toDouble(), y as double, z as double),
      //
      //           weight: random.nextInt(1000),
      //           buildingId: random.nextInt(5),
      //           buildingName: 'Building Name ${goodsId++}',
      //           detailAddress: '서울시 강남구 삼성동 123-456'));
      //     }
      //   }
      // }



      return goods;
    } else {
      throw Exception('Failed to load goods');
    }
  }
}
