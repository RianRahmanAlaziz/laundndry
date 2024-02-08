import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/promo_model.dart';
import '../models/shop_model.dart';

final homeCategoryProvider = StateProvider.autoDispose((ref) => 'All');
final homePromoStatusProvider = StateProvider.autoDispose((ref) => '');
final homeShopStatusProvider = StateProvider.autoDispose((ref) => '');
final homeRecommendationStatusProvider = StateProvider.autoDispose((ref) => '');

setHomeCategory(WidgetRef ref, String newCategory) {
  ref.read(homeCategoryProvider.notifier).state = newCategory;
}

setHomeShopStatus(WidgetRef ref, String newStatus) {
  ref.read(homeShopStatusProvider.notifier).state = newStatus;
}

setHomePromoStatus(WidgetRef ref, String newStatus) {
  ref.read(homePromoStatusProvider.notifier).state = newStatus;
}

setHomeRecommendationStatus(WidgetRef ref, String newStatus) {
  ref.read(homeRecommendationStatusProvider.notifier).state = newStatus;
}

final homeShopCategoryListProvider =
    StateNotifierProvider.autoDispose<HomeShopCategoryList, List<ShopModel>>(
        (ref) => HomeShopCategoryList([]));

class HomeShopCategoryList extends StateNotifier<List<ShopModel>> {
  HomeShopCategoryList(super.state);

  setData(List<ShopModel> newData) {
    state = newData;
  }
}

final homePromoListProvider =
    StateNotifierProvider.autoDispose<HomePromoList, List<PromoModel>>(
        (ref) => HomePromoList([]));

class HomePromoList extends StateNotifier<List<PromoModel>> {
  HomePromoList(super.state);

  setData(List<PromoModel> newData) {
    state = newData;
  }
}

final homeRecommendationListProvider =
    StateNotifierProvider.autoDispose<HomeRecommendationList, List<ShopModel>>(
        (ref) => HomeRecommendationList([]));

class HomeRecommendationList extends StateNotifier<List<ShopModel>> {
  HomeRecommendationList(super.state);

  setData(List<ShopModel> newData) {
    state = newData;
  }
}
