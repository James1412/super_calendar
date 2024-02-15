class HolidayModel {
  String date;
  String holidayName;
  String countryCode;

  HolidayModel({
    required this.date,
    required this.holidayName,
    required this.countryCode,
  });

  HolidayModel.fromJson(Map<String, dynamic> json)
      : countryCode = json["countryCode"],
        holidayName = json['localName'],
        date = json['date'];
}
