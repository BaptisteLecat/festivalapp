import 'package:festivalapp/model/barcode.dart';
import 'package:festivalapp/services/api/main_fetcher.dart';

class BarcodeFetcher extends MainFetcher {
  Future<List<Barcode>> getBarcodeList() async {
    final response = await get(url: "barcodes");
    print(response.content);
    return listBarcodeFromJson(response.content);
  }
}
