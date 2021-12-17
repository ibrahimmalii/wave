class serviceModel {
  int ?id;
  String? title;
  String? description;
  int? smallPrice;
  int? midPrice;
  int? largePrice;
  String? createdAt;
  String? updatedAt;

  serviceModel(
      {
        this.id,
        this.title,
        this.description,
        this.smallPrice,
        this.midPrice,
        this.largePrice,
        this.createdAt,
        this.updatedAt});

  serviceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    smallPrice = json['small_price'];
    midPrice = json['mid_price'];
    largePrice = json['large_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['small_price'] = this.smallPrice;
    data['mid_price'] = this.midPrice;
    data['large_price'] = this.largePrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}