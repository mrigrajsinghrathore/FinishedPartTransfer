class dbModelAddInformation {
  int? id;
  String? barCodeNo;
  String? productName;
  String? manufacturingPlant;
  String? productDimension;
  String? Description;
  String? Review;
  String? ProductionCompanyId;
  String? QaQcRemark;
  String? QaQcStatus;
  String? QaQcCompanyId;
  String? StoreRemark;
  String? StoreStatus;
  String? StoreCompanyId;

  dbModelAddInformation(
      {this.id,
        this.barCodeNo,
        this.productName,
        this.manufacturingPlant,
        this.productDimension,
        this.Description,
        this.Review,
        this.ProductionCompanyId,
        this.QaQcRemark,
        this.QaQcStatus,
        this.QaQcCompanyId,
        this.StoreRemark,
        this.StoreStatus,
        this.StoreCompanyId
      });

  factory dbModelAddInformation.formMap(Map<String, dynamic> map) {
    return dbModelAddInformation(
      id: map['id'],
      barCodeNo: map['barCodeNo'],
      productName: map['productName'],
      manufacturingPlant: map['manufacturingPlant'],
      productDimension: map['productDimension'],
      Description: map['Description'],
      Review: map['Review'],
      ProductionCompanyId: map['ProductionCompanyId'] ,
      QaQcRemark: map['QaQcRemark'],
      QaQcStatus: map['QaQcStatus'],
      QaQcCompanyId: map['QaQcCompanyId'],
      StoreRemark: map['StoreRemark'],
      StoreStatus: map['StoreStatus'],
      StoreCompanyId: map['StoreCompanyId']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'barCodeNo': barCodeNo,
      'productName': productName,
      'manufacturingPlant': manufacturingPlant,
      'productDimension': productDimension,
      'Description': Description,
      'Review': Review,
      'ProductionCompanyId': ProductionCompanyId,
      'QaQcRemark':QaQcRemark,
      'QaQcStatus':QaQcStatus,
      'QaQcCompanyId':QaQcCompanyId,
      'StoreRemark':QaQcRemark,
      'StoreStatus':StoreStatus,
      'StoreCompanyId':StoreCompanyId


    };
  }
}