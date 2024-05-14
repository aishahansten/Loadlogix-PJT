import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../components/nav_rail.dart';
import 'goodsdummy.dart';

String toDay = DateFormat('yyyy.MM.dd').format(DateTime.now()); //today나타내기

@RoutePage()
class DeliveryListPage extends StatelessWidget {
  const DeliveryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('적재 전 배송리스트'), // 앱바 타이틀
      ),
      body: Row(children: [
        MyNav(),
        Expanded(
          child:
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, top: 10),
                    child: Text('님의 $toDay일 Loading List입니다.'),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(border: Border.all()),
                      child: DataTable(
                        headingRowColor:
                            MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                            return Colors.blue;
                          }, // 헤더 행의 배경색
                        ),
                        columns: const [
                          DataColumn(label: Text('No')),
                          DataColumn(label: Text('주소')),
                          DataColumn(label: Text('구역')),
                          DataColumn(label: Text('바코드')),
                          DataColumn(label: Text('태백규격(cm)')),
                          DataColumn(label: Text('상품무게(g)')),
                        ],
                        rows: List<DataRow>.generate(goodsList.length, (index) {
                          final good = goodsList[index];
                          return DataRow(
                            cells: [
                              DataCell(Text('${good.goodsId}')),
                              DataCell(Text(good.area)),
                              DataCell(Text('...')),
                              DataCell(Text('...')),
                              DataCell(Text(
                                  '${good.height} x ${good.length} x ${good.width}')),
                              DataCell(Text('${good.weight}g')),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}