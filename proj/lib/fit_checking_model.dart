class FitCheckingData {
  String date;
  double height;
  double weight;
  int bp;
  double bmi;
  String bmiCategory;
  String bpStatus;

  FitCheckingData({
    required this.date,
    required this.height,
    required this.weight,
    required this.bp,
    required this.bmi,
    required this.bmiCategory,
    required this.bpStatus,
  });

  // Factory method to create a FitCheckingData object from JSON
  factory FitCheckingData.fromJson(Map<String, dynamic> json) => FitCheckingData(
        date: json['date'],
        height: json['height'],
        weight: json['weight'],
        bp: json['bp'],
        bmi: json['bmi'],
        bmiCategory: json['bmiCategory'],
        bpStatus: json['bpStatus'],
      );

  // Method to convert a FitCheckingData object to JSON
  Map<String, dynamic> toJson() => {
        'date': date,
        'height': height,
        'weight': weight,
        'bp': bp,
        'bmi': bmi,
        'bmiCategory': bmiCategory,
        'bpStatus': bpStatus,
      };
}
