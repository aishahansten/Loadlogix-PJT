import 'package:flutter/material.dart';
import 'package:load_frontend/models/good_data.dart';
import 'package:load_frontend/stores/goods_store.dart';
import 'package:provider/provider.dart';

class GoodsExpansionPanel extends StatelessWidget {
  const GoodsExpansionPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final goodsStore = context.watch<GoodsStore>();
    final Map<int, List<GoodsData>> groupedGoods = goodsStore.goodsGroupedByBuildingId;

    return Column(
      children: [
        ...groupedGoods.entries.map((entry) {
          int buildingId = entry.key;
          List<GoodsData> goods = entry.value;
          return ExpansionTile(
            leading: Checkbox(
              value: goodsStore.isBuildingChecked(buildingId),
              onChanged: (bool? checked) {
                goodsStore.toggleBuilding(buildingId);
              },
            ),
            title: Text('${goods[0].buildingName}'),
            children: goods.map((good) {
              return Padding(
                padding: EdgeInsets.only(left: 16.0),
                child: ListTile(
                  leading: Checkbox(
                    value: goodsStore.isGoodChecked(buildingId, good.goodsId),
                    onChanged: (bool? checked) {
                      goodsStore.toggleGood(buildingId, good.goodsId);
                    },
                  ),
                  title: Text("Goods ID ${good.goodsId}"),
                  subtitle: Text('Type: ${good.type}, Weight: ${good.weight}'),
                ),
              );
            }).toList(),
          );
        }).toList(),
      ],
    );
  }
}