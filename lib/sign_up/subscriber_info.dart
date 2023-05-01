/*
memberName*	[...]
memberIntro*	[...]
memberHeight	[...]
bodyInfo	[...]
language	[...]
drinkInfo	[...]
smokingInfo	[...]
memberTendencyCd*	[...]
searchTendencyCd1*	[...]
searchTendencyCd2	[...]
searchTendencyCd3	[...]
memberPhone*	[...]
memberBirthday*	[...]
latitude	[...]
longitude	[...]
address	[...]
address2	[...]
address3	[...]
ci	[...]
 */

class SubscriberInfo {
  static final SubscriberInfo _singleton = SubscriberInfo._internal();

  String? phoneNumber;

  String? iam;
  List<String> toFind = [];

  String? name;
  String? birthDay;
  String? aboutMe;
  int? height;
  String? bodyType;
  String? languageSpoken;
  String? drink;
  String? smoking;

  List<String> profileImages = [];

  double? latitude;
  double? longitude;

  String? address;
  String? address2;
  String? address3;
  String? ci;

  factory SubscriberInfo() {
    return _singleton;
  }

  SubscriberInfo._internal();
}

const List<Map<String, String>> tendencies = [
  {'label': '부부', 'code': 'T0000'},
  {'label': '커플-남녀', 'code': 'T1000'},
  {'label': '커플-남남', 'code': 'T1001'},
  {'label': '커플-여여', 'code': 'T1002'},
  {'label': '싱글-여성', 'code': 'T2000'},
  {'label': '싱글-남성', 'code': 'T2001'},
  {'label': 'BDSM-멜돔', 'code': 'T3000'},
  {'label': 'BDSM-멜섭', 'code': 'T3001'},
  {'label': 'BDSM-멜스위치', 'code': 'T3002'},
  {'label': 'BDSM-펨돔', 'code': 'T3100'},
  {'label': 'BDSM-펨섭', 'code': 'T3101'},
  {'label': 'BDSM-펨스위치', 'code': 'T3102'},
  {'label': 'LGBT-레즈비언-부치', 'code': 'T4000'},
  {'label': 'LGBT-레즈비언-펨', 'code': 'T4001'},
  {'label': 'LGBT-레즈비언-온기브', 'code': 'T4002'},
  {'label': 'LGBT-레즈비언-온텍', 'code': 'T4003'},
  {'label': 'LGBT-레즈비언-전천', 'code': 'T4004'},
  {'label': 'LGBT-게이-탑', 'code': 'T4100'},
  {'label': 'LGBT-게이-바텀', 'code': 'T4101'},
  {'label': 'LGBT-게이-올탑', 'code': 'T4102'},
  {'label': 'LGBT-게이-올바텀', 'code': 'T4103'},
  {'label': 'LGBT-게이-비선호', 'code': 'T4104'},
  {'label': '양성애', 'code': 'T5000'},
  {'label': '트랜스젠더-시디', 'code': 'T6001'},
  {'label': '트랜스젠더-쉬멜', 'code': 'T6002'},
  {'label': '트랜스젠더-트렌스젠더', 'code': 'T6003'},
  {'label': '트랜스젠더-러버', 'code': 'T6004'},
  {'label': '그외', 'code': 'T9999'}
];

const List<Map<String, String>> bodyTypes = [
  {'label': '날씬한', 'code': 'B0000'},
  {'label': '건강한', 'code': 'B0001'},
  {'label': '평균의', 'code': 'B0002'},
  {'label': '굴곡이 많은', 'code': 'B0003'},
  {'label': '탄탄한', 'code': 'B0004'},
  {'label': '근육질의', 'code': 'B0005'},
  {'label': '살집이 있는', 'code': 'B0006'},
  {'label': '과체중의', 'code': 'B0007'},
  {'label': '그외', 'code': 'B9999'},
];

const List<Map<String, String>> frequencies = [
  {'label': '안함', 'code': 'D0000'},
  {'label': '가끔', 'code': 'D0001'},
  {'label': '종종', 'code': 'D0002'},
  {'label': '매일', 'code': 'D0003'},
  {'label': '그외', 'code': 'D9999'},
];

const List<Map<String, String>> languages = [
  {'label': '광동어', 'code': 'L0000'},
  {'label': '그리스어', 'code': 'L0001'},
  {'label': '네덜란드어', 'code': 'L0002'},
  {'label': '네팔어', 'code': 'L0003'},
  {'label': '독일어', 'code': 'L0004'},
  {'label': '러시아어', 'code': 'L0005'},
  {'label': '루마니아어', 'code': 'L0006'},
  {'label': '말라가시어', 'code': 'L0007'},
  {'label': '말레이어', 'code': 'L0008'},
  {'label': '버마어', 'code': 'L0009'},
  {'label': '베트남어', 'code': 'L0010'},
  {'label': '벨라루스어', 'code': 'L0011'},
  {'label': '벵골어', 'code': 'L0012'},
  {'label': '세르비아어', 'code': 'L0013'},
  {'label': '소말리아어', 'code': 'L0014'},
  {'label': '스웨덴어', 'code': 'L0015'},
  {'label': '스페인어', 'code': 'L0016'},
  {'label': '아랍어', 'code': 'L0017'},
  {'label': '아이티크레올어', 'code': 'L0018'},
  {'label': '아제리어', 'code': 'L0019'},
  {'label': '암하라어', 'code': 'L0020'},
  {'label': '영어', 'code': 'L0021'},
  {'label': '요루바어', 'code': 'L0022'},
  {'label': '우즈베크어', 'code': 'L0023'},
  {'label': '우크라이나어', 'code': 'L0024'},
  {'label': '이탈리아어', 'code': 'L0025'},
  // {'label': '--인도어', 'code': 'L0026'},
  {'label': '일본어', 'code': 'L0027'},
  {'label': '중국어', 'code': 'L0028'},
  {'label': '체코어', 'code': 'L0029'},
  {'label': '카자흐어', 'code': 'L0030'},
  {'label': '케추아어', 'code': 'L0031'},
  {'label': '캄보디아어', 'code': 'L0032'},
  {'label': '태국어', 'code': 'L0033'},
  {'label': '튀르키예어', 'code': 'L0034'},
  {'label': '투르크멘어', 'code': 'L0035'},
  {'label': '포르투갈어', 'code': 'L0036'},
  {'label': '폴란드어', 'code': 'L0037'},
  {'label': '프랑스어', 'code': 'L0038'},
  {'label': '한국어', 'code': 'L0039'},
  {'label': '헝가리어', 'code': 'L0040'},
  {'label': '힌디어', 'code': 'L0041'},
];
