import 'package:social_app/app/core/base/base_model.dart';

class BaseSearchRequestModel extends BaseModel<BaseSearchRequestModel> {
  int? page;
  int? pageSize;
  String? sortBy;
  String? sortType;
  DateTime? fromDate;
  DateTime? toDate;

  BaseSearchRequestModel({this.page = 1, this.pageSize = 25, this.sortBy, this.sortType, this.fromDate, this.toDate});

  @override
  BaseSearchRequestModel fromJson(Map<String, dynamic> json) => BaseSearchRequestModel(
        page: (json['Page'] as num?)?.toInt(),
        pageSize: (json['PageSize'] as num?)?.toInt(),
        sortBy: json['SortBy'],
        sortType: json['SortType'],
        fromDate: json['FromDate'] != null ? DateTime.tryParse(json['FromDate']) : null,
        toDate: json['ToDate'] != null ? DateTime.tryParse(json['ToDate']) : null,
      );

  @override
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (page != null) {
      data['Page'] = page;
    }
    if (pageSize != null) {
      data['PageSize'] = pageSize;
    }
    if (sortBy != null) {
      data['SortBy'] = sortBy;
    }
    if (sortType != null) {
      data['SortType'] = sortType;
    }
    if (fromDate != null) {
      data['FromDate'] = fromDate?.toIso8601String();
    }
    if (toDate != null) {
      data['ToDate'] = toDate?.toIso8601String();
    }
    return data;
  }

  BaseSearchRequestModel copyWith({
    int? page,
    int? pageSize,
    String? sortBy,
    String? sortType,
    DateTime? fromDate,
    DateTime? toDate,
  }) =>
      BaseSearchRequestModel(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        sortBy: sortBy ?? this.sortBy,
        sortType: sortType ?? this.sortType,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
      );
}
