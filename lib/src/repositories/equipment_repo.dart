import 'package:film_management/src/models/equipment.dart';
import 'package:film_management/src/providers/equipment_provider.dart';
import 'package:http/http.dart';

class EquipmentRepo {
  final _provider = EquipmentProvider();

  Future<Response> getAllEquipment() {
    return _provider.getAllEquipment();
  }

  Future<Response> getById(int id) {
    return _provider.getEquipmentById(id);
  }

  Future<Response> addEquipment(Equipment equipment) {
    return _provider.addEquipment(equipment);
  }

  Future<Response> updateEquipment(Equipment equipment) {
    return _provider.updateEquipment(equipment);
  }

  Future<Response> deleteEquipment(num id) {
    return _provider.deleteEquipment(id);
  }
  Future<Response> getListWithAvaiQuantity(
      String timeStart, String timeEnd) {
    
    return _provider.getListWithAvaiQuantity(timeStart, timeEnd);
  }
}