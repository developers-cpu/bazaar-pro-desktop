import '../models/rule_model.dart';

abstract class RulesRemoteDataSource {
  Future<List<RuleModel>> getRules();
}

class RulesRemoteDataSourceImpl implements RulesRemoteDataSource {
  @override
  Future<List<RuleModel>> getRules() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      const RuleModel(
        id: '1',
        language: 'en',
        rule:
            'IF YOU ARE NOT AGREEING WITH THE RULES & REGULATIONS, KINDLY DO NOT START WORK.',
      ),
      const RuleModel(
        id: '2',
        language: 'en',
        rule: 'TRADING TIME – TRADING STARTS AFTER ONE MINUTE OF MARKET HOURS.',
      ),
      const RuleModel(
        id: '3',
        language: 'en',
        rule:
            'PENDING TRADES WILL BE AUTOMATICALLY DELETED AFTER MARKET CLOSES.',
      ),
      const RuleModel(
        id: '4',
        language: 'en',
        rule:
            'BUY LIMIT / SELL LIMIT AND BUY STOP LOSS / SELL STOP LOSS WILL BE EXECUTED BY BID/ASK PRICES AND NOT LTP RESPECTIVELY.',
      ),
      const RuleModel(
        id: '5',
        language: 'en',
        rule:
            'ONLY POSITION SQUARE-OFF WILL BE ALLOWED IN BANNED SYMBOLS; NO NEW TRADES WILL BE ACCEPTED.',
      ),
      const RuleModel(
        id: '6',
        language: 'en',
        rule:
            'EXECUTED TRADES CANNOT BE EDITED OR DELETED BY MASTERS, USERS, OR SYSTEM ADMIN.',
      ),
      const RuleModel(
        id: '7',
        language: 'en',
        rule:
            'DURING BUY CIRCUIT, NO NEW BUY WILL BE ACCEPTED, OR SELL POSITION ALLOWED TO SQUARE-OFF;; VICE VERSA DURING SELL CIRCUIT.',
      ),
      const RuleModel(
        id: '8',
        language: 'en',
        rule:
            'LINE TRADES WILL BE NULLED BY SYSTEM ADMIN ANYTIME. NO ARGUMENT ACCEPTED.',
      ),
      const RuleModel(
        id: '9',
        language: 'en',
        rule:
            'CARRY FORWARD AND BILL GENERATION WILL BE DONE AT 12:00 EVERY SATURDAY IST.',
      ),
      const RuleModel(
        id: '10',
        language: 'en',
        rule:
            'IF YOU FACE ANY ISSUES WHILE CLOSING TRADE FROM MARKET WATCH, CLOSE THAT POSITION FROM PORTFOLIO.',
      ),
      const RuleModel(
        id: '11',
        language: 'en',
        rule:
            'IF WE FIND THE SAME IP ADDRESS IN TWO OR MORE CLIENT IDs, PROFIT TRADE WILL BE DELETED AND LOSS WILL BE TAKEN BY YOU.',
      ),
      const RuleModel(
        id: '12',
        language: 'en',
        rule:
            'YOU CANNOT SQR-OFF PROFIT TRADE BEFORE 15 MIN — ONLY LOSS TRADE CAN BE SQR-OFF.',
      ),
      const RuleModel(
        id: '13',
        language: 'en',
        rule:
            'YOU CAN\'T CUT PROFITABLE TRADE BY LIMIT / STOP-LOSS WITHIN 15 MIN.',
      ),
      const RuleModel(
        id: '14',
        language: 'en',
        rule:
            'DIVIDEND WILL BE SUBTRACTED FROM PORTFOLIO BEFORE THE DAY OF DIVIDEND. NO DIVIDEND WILL BE GIVEN.',
      ),
      const RuleModel(
        id: '15',
        language: 'en',
        rule:
            'YOU CANNOT HOLD YOUR POSITION FOR MORE THAN 15 DAYS; ON THE 16TH DAY IT WILL BE CANCELLED.',
      ),
      const RuleModel(
        id: '16',
        language: 'en',
        rule:
            'YOU CAN\'T PUT LIMIT / STOP-LOSS WITHIN 15 MIN AFTER MARKET OPEN.',
      ),
      const RuleModel(
        id: '17',
        language: 'en',
        rule:
            'BTST, STBT, SCALPING, JOBBING TRADE NOT ALLOWED (ONLY PROFITABLE TRADE WILL BE DELETED).',
      ),
      const RuleModel(
        id: '18',
        language: 'en',
        rule: 'ANY SUSPICIOUS TRADE WILL BE DELETED BEFORE BILL GENERATION.',
      ),
      const RuleModel(
        id: '19',
        language: 'en',
        rule:
            'WHEN THERE IS A GAP-UP OR GAP-DOWN, ACTUAL LOSS WILL BE COUNTED. EVEN IF YOUR CREDIT IS 5 LAKH AND LOSS IS 7 LAKH, COMPLETE LOSS OF 7 LAKH WILL BE CONSIDERED.',
      ),
      const RuleModel(
        id: '20',
        language: 'hi',
        rule: 'यदि आप नियम व शर्तों से सहमत नहीं हैं तो कृपया काम शुरू न करें',
      ),
      const RuleModel(
        id: '21',
        language: 'hi',
        rule: 'ट्रेडिंग समय - बाजार खुलने के 1 मिनट बाद ट्रेडिंग शुरू होगी',
      ),
      const RuleModel(
        id: '22',
        language: 'hi',
        rule:
            'बाजार बंद होने के बाद लंबित ट्रेड स्वचालित रूप से हटा दिए जाएंगे',
      ),
      const RuleModel(
        id: '23',
        language: 'hi',
        rule:
            'खरीद सीमा / बिक्री सीमा और खरीद स्टॉप लॉस / बिक्री स्टॉप लॉस आदेश बोली / पूछ मूल्य पर निष्पादित किए जाएंगे, एलटीपी पर नहीं',
      ),
      const RuleModel(
        id: '24',
        language: 'hi',
        rule:
            'प्रतिबंधित स्क्रिप्ट में केवल पोजीशन स्क्वायर-ऑफ की अनुमति है; कोई नया ट्रेड नहीं लिया जाएगा',
      ),
      const RuleModel(
        id: '25',
        language: 'hi',
        rule:
            'निष्पादित ट्रेड्स को संपादित या हटाया नहीं जा सकता - न तो मास्टर, उपयोगकर्ता, न ही सिस्टम एडमिन',
      ),
      const RuleModel(
        id: '26',
        language: 'hi',
        rule:
            'खरीद सर्किट के दौरान, कोई नई खरीद स्वीकार नहीं की जाएगी और केवल बिक्री की स्थिति को ही समाप्त किया जाएगा; बिक्री सर्किट के दौरान इसके विपरीत होगा',
      ),
      const RuleModel(
        id: '27',
        language: 'hi',
        rule:
            'लाइन ट्रेड्स को सिस्टम एडमिन द्वारा किसी भी समय रद्द किया जा सकता है - कोई आपत्ति स्वीकार नहीं की जाती है',
      ),
      const RuleModel(
        id: '28',
        language: 'hi',
        rule:
            'आगे ले जाने और बिल बनाने का कार्य प्रत्येक शनिवार को दोपहर 12 बजे किया जाएगा',
      ),
      const RuleModel(
        id: '29',
        language: 'hi',
        rule:
            'यदि ट्रेड मार्केट वॉच के साथ बंद नहीं होता है, तो पोर्टफोलियो से स्थिति को बंद कर दें',
      ),
      const RuleModel(
        id: '30',
        language: 'hi',
        rule:
            'यदि दो या अधिक क्लाइंट आईडी में एक ही आईपी पता पाया जाता है, तो PROFIT ट्रेड हटा दिया जाएगा और नुकसान आपका होगा',
      ),
      const RuleModel(
        id: '31',
        language: 'hi',
        rule:
            '15 मिनट से पहले लाभ वाले व्यापार को समाप्त नहीं किया जा सकता - केवल हानि वाले व्यापार को ही समाप्त किया जा सकता है',
      ),
      const RuleModel(
        id: '32',
        language: 'hi',
        rule:
            'आप 15 मिनट के भीतर LIMIT/STOP-LOSS नहीं लगा सकते और PROFIT ट्रेड नहीं कर सकते',
      ),
      const RuleModel(
        id: '33',
        language: 'hi',
        rule:
            'लाभांश के दिन से पहले पोर्टफोलियो से लाभांश घटा दिया जाएगा कोई लाभांश नहीं दिया जाएगा',
      ),
      const RuleModel(
        id: '34',
        language: 'hi',
        rule:
            'आप 15 दिन से अधिक समय तक अपना पद नहीं रख सकते; 16वें दिन यह रद्द हो जाएगा',
      ),
      const RuleModel(
        id: '35',
        language: 'hi',
        rule: 'आप बाजार खुलने के 15 मिनट के भीतर लिमिट/स्टॉप-लॉस नहीं लगा सकते',
      ),
      const RuleModel(
        id: '36',
        language: 'hi',
        rule:
            'बीटीएसटी, एसटीबीटी, स्केल्पिंग, जॉबिंग व्यापार की अनुमति नहीं है (केवल लाभदायक व्यापार को हटाया जाएगा)',
      ),
      const RuleModel(
        id: '37',
        language: 'hi',
        rule: 'किसी भी संदिग्ध व्यापार को बिल बनाने से पहले हटा दिया जाएगा',
      ),
      const RuleModel(
        id: '38',
        language: 'hi',
        rule:
            'जब गैप-अप या गैप-डाउन होता है, तो वास्तविक नुकसान गिना जाएगा भले ही आपका क्रेडिट 5 लाख हो और नुकसान 7 लाख हो, 7 लाख का पूरा नुकसान गिना जाएगा',
      ),
      const RuleModel(
        id: '39',
        language: 'gu',
        rule:
            'જો તમે નિયમો અને શરતો સાથે સહમત ન હો, તો કૃપા કરીને કામ શરૂ ન કરો.',
      ),
      const RuleModel(
        id: '40',
        language: 'gu',
        rule: 'ટ્રેડિંગ સમય – માર્કેટ ખુલ્યા પછી 1 મિનિટે ટ્રેડિંગ શરૂ થશે.',
      ),
      const RuleModel(
        id: '41',
        language: 'gu',
        rule: 'પેન્ડિંગ ટ્રેડ્સ માર્કેટ બંધ થયા પછી ઓટોમેટિકલી ડિલીટ થશે.',
      ),
      const RuleModel(
        id: '42',
        language: 'gu',
        rule:
            'BUY LIMIT / SELL LIMIT અને BUY STOP LOSS / SELL STOP LOSS ઓર્ડર LTP પર નહીં, પરંતુ BID/ASK પ્રાઈસ પર એક્ઝિક્યુટ થશે.',
      ),
      const RuleModel(
        id: '43',
        language: 'gu',
        rule:
            'બેન થયેલ સ્ક્રિપ્ટ્સમાં માત્ર પોઝિશન સ્ક્વેર-ઓફ કરવાની મંજૂરી; નવા ટ્રેડ લેવામાં આવશે નહીં.',
      ),
      const RuleModel(
        id: '44',
        language: 'gu',
        rule:
            'Executed ટ્રેડ્સ એડિટ અથવા ડિલીટ કરી શકાશે નહીં — માસ્ટર, યુઝર કે સિસ્ટમ એડમિન કોઈ નહીં કરી શકે.',
      ),
      const RuleModel(
        id: '45',
        language: 'gu',
        rule:
            'BUY CIRCUIT દરમિયાન નવો BUY સ્વીકારાશે નહીં અને SELL પોઝિશન જ સ્ક્વેર-ઓફ થશે; SELL CIRCUIT દરમિયાન તેનો વિપરીત.',
      ),
      const RuleModel(
        id: '46',
        language: 'gu',
        rule:
            'LINE ટ્રેડ્સ સિસ્ટમ એડમિન કોઈપણ સમયે રદ્દ કરી શકે — કોઈ વાંધો માન્ય નથી.',
      ),
      const RuleModel(
        id: '47',
        language: 'gu',
        rule: 'દર શનિવારે બપોરે 12:00 વાગે કેરી ફોરવર્ડ અને બિલ જનરેશન થશે.',
      ),
      const RuleModel(
        id: '48',
        language: 'gu',
        rule:
            'માર્કેટ વોચથી ટ્રેડ ક્લોઝ ન થાય તો પોર્ટફોલિયોમાંથી પોઝિશન ક્લોઝ કરો.',
      ),
      const RuleModel(
        id: '49',
        language: 'gu',
        rule:
            'એક જ IP Address બે કે વધુ ક્લાયન્ટ ID માં મળ્યો તો PROFIT ટ્રેડ ડિલીટ થશે અને નુકસાન તમારું ગણાશે.',
      ),
      const RuleModel(
        id: '50',
        language: 'gu',
        rule:
            '15 મિનિટ પહેલાં PROFIT ટ્રેડ સ્ક્વેર-ઓફ કરી શકતા નથી — માત્ર LOSS ટ્રેડ કરી શકો.',
      ),
      const RuleModel(
        id: '51',
        language: 'gu',
        rule:
            '15 મિનિટ અંદર LIMIT / STOP-LOSS મુકી PROFIT ટ્રેડ કટ કરી શકતા નથી.',
      ),
      const RuleModel(
        id: '52',
        language: 'gu',
        rule:
            'ડિવિડેન્ડના દિવસે પહેલાં પોર્ટફોલિયોમાંથી ડિવિડેન્ડ કાપી લેવાશે. અમે કોઈ ડિવિડેન્ડ આપતા નથી.',
      ),
      const RuleModel(
        id: '53',
        language: 'gu',
        rule:
            'તમે 15 દિવસથી વધુ પોઝિશન રાખી શકતા નથી; 16મા દિવસે સિસ્ટમ આપમેળે રદ્દ કરશે.',
      ),
      const RuleModel(
        id: '54',
        language: 'gu',
        rule:
            'માર્કેટ ખુલ્યા પછી 15 મિનિટ સુધી LIMIT / STOP-LOSS ઓર્ડર મૂકવામાં આવશે નહીં.',
      ),
      const RuleModel(
        id: '55',
        language: 'gu',
        rule:
            'BTST, STBT, SCALPING, JOBBING ટ્રેડ્સની મંજૂરી નથી (પ્રોફિટ વાળા ટ્રેડ કાઢી નાખવામાં આવશે).',
      ),
      const RuleModel(
        id: '56',
        language: 'gu',
        rule: 'કોઈપણ શંકાસ્પદ ટ્રેડ બિલ જનરેટ થાય તે પહેલાં ડિલીટ થશે.',
      ),
      const RuleModel(
        id: '57',
        language: 'gu',
        rule:
            'GAP-UP અથવા GAP-DOWN થાય ત્યારે વાસ્તવિક નુકસાન ગણાશે. તમારું ક્રેડિટ 5 લાખ હોય અને નુકસાન 7 લાખ થાય તો પૂરા 7 લાખનું નુકસાન ગણાશે.',
      ),
    ];
  }
}
