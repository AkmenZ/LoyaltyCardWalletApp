import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/brands.dart';

part 'brands_provider.g.dart';

@riverpod
Future<List<Brands>> brandsList(Ref ref) async {
  final data = await rootBundle.loadString('assets/data/brands.json');
  final List<dynamic> jsonResult = json.decode(data);
  return jsonResult.map((e) => Brands.fromJson(e)).toList();
}
