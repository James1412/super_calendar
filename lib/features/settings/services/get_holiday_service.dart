import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:super_calendar/features/settings/models/holiday_model.dart';

Map<String, String> countries = {
  "No Holidays": "",
  'Andorra': 'AD',
  'Albania': 'AL',
  'Argentina': 'AR',
  'Austria': 'AT',
  'Australia': 'AU',
  'Åland Islands': 'AX',
  'Bosnia and Herzegovina': 'BA',
  'Barbados': 'BB',
  'Belgium': 'BE',
  'Bulgaria': 'BG',
  'Benin': 'BJ',
  'Bolivia': 'BO',
  'Brazil': 'BR',
  'Bahamas': 'BS',
  'Botswana': 'BW',
  'Belarus': 'BY',
  'Belize': 'BZ',
  'Canada': 'CA',
  'Switzerland': 'CH',
  'Chile': 'CL',
  'China': 'CN',
  'Colombia': 'CO',
  'Costa Rica': 'CR',
  'Cuba': 'CU',
  'Cyprus': 'CY',
  'Czechia': 'CZ',
  'Germany': 'DE',
  'Denmark': 'DK',
  'Dominican Republic': 'DO',
  'Ecuador': 'EC',
  'Estonia': 'EE',
  'Egypt': 'EG',
  'Spain': 'ES',
  'Finland': 'FI',
  'Faroe Islands': 'FO',
  'France': 'FR',
  'Gabon': 'GA',
  'United Kingdom': 'GB',
  'Grenada': 'GD',
  'Guernsey': 'GG',
  'Gibraltar': 'GI',
  'Greenland': 'GL',
  'Gambia': 'GM',
  'Greece': 'GR',
  'Guatemala': 'GT',
  'Guyana': 'GY',
  'Honduras': 'HN',
  'Croatia': 'HR',
  'Haiti': 'HT',
  'Hungary': 'HU',
  'Indonesia': 'ID',
  'Ireland': 'IE',
  'Isle of Man': 'IM',
  'Iceland': 'IS',
  'Italy': 'IT',
  'Jersey': 'JE',
  'Jamaica': 'JM',
  'Japan': 'JP',
  'South Korea': 'KR',
  'Liechtenstein': 'LI',
  'Lesotho': 'LS',
  'Lithuania': 'LT',
  'Luxembourg': 'LU',
  'Latvia': 'LV',
  'Morocco': 'MA',
  'Monaco': 'MC',
  'Moldova': 'MD',
  'Montenegro': 'ME',
  'Madagascar': 'MG',
  'North Macedonia': 'MK',
  'Mongolia': 'MN',
  'Montserrat': 'MS',
  'Malta': 'MT',
  'Mexico': 'MX',
  'Mozambique': 'MZ',
  'Namibia': 'NA',
  'Niger': 'NE',
  'Nigeria': 'NG',
  'Nicaragua': 'NI',
  'Netherlands': 'NL',
  'Norway': 'NO',
  'New Zealand': 'NZ',
  'Panama': 'PA',
  'Peru': 'PE',
  'Papua New Guinea': 'PG',
  'Poland': 'PL',
  'Puerto Rico': 'PR',
  'Portugal': 'PT',
  'Paraguay': 'PY',
  'Romania': 'RO',
  'Serbia': 'RS',
  'Russia': 'RU',
  'Sweden': 'SE',
  'Singapore': 'SG',
  'Slovenia': 'SI',
  'Svalbard and Jan Mayen': 'SJ',
  'Slovakia': 'SK',
  'San Marino': 'SM',
  'Suriname': 'SR',
  'El Salvador': 'SV',
  'Tunisia': 'TN',
  'Turkey': 'TR',
  'Ukraine': 'UA',
  'United States': 'US',
  'Uruguay': 'UY',
  'Vatican City': 'VA',
  'Venezuela': 'VE',
  'Vietnam': 'VN',
  'South Africa': 'ZA',
  'Zimbabwe': 'ZW',
};

class GetHolidayService {
  // https://date.nager.at/swagger/index.html
  Future<List<HolidayModel>> fetchHolidays(String countryCode) async {
    List<HolidayModel> holidays = [];
    int year = DateTime.now().year;
    final response = await http.get(
      Uri.parse(
          'https://date.nager.at/api/v3/publicholidays/$year/$countryCode'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> resultList = jsonDecode(response.body);
      for (var holidayJson in resultList) {
        HolidayModel holiday = HolidayModel.fromJson(holidayJson);
        holidays.add(holiday);
      }
      return holidays;
    } else {
      throw Exception("Failed to load holidays");
    }
  }
}
