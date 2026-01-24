import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/color.dart';

class Links extends StatefulWidget {
  @override
  _LinksState createState() => _LinksState();
}

class _LinksState extends State<Links> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/koky.jpg"),
          fit: BoxFit.cover,
          colorFilter: new ColorFilter.mode(
              Colors.black.withOpacity(0.2), BlendMode.dstATop),
        )),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                textDirection: TextDirection.rtl,
                children: <Widget>[
                  Text(
                    "يمكنكم التفاعل معنا على صفحة الفيسبوك وإرسال أسئلتكم التي ايا كانت وسيجيبكم عنها اصدقاء الصفحة",
                    textAlign: TextAlign.center,
                  ),
                  Center(
                    child: ButtonTheme(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 12.0), //adds padding inside the button
                      materialTapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, //limits the touch area to the button area
                      minWidth: 0, //wraps child's width
                      height: 0, //wraps child's height
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: RaisedButton(
                        color: Colors.white70,
                        child: FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Colors.purple[400],
                          size: 32.0,
                        ),
                        onPressed: () {
                          _launchURL();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(10)),
                width: MediaQuery.of(context).size.width,
                height: 330,
//                color: Colors.black54,
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "assets/images/facebook.png",
                            height: 30,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Text("دليل المرأة الحامل "),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/images/logo3.png",
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("أعراض الحمل خارج الرحم .."),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                          "يمكن أن تكون أعراض الحمل خارج الرحم مشابهة لأعراض الإجهاض في النزف والألم فى الجزء السفلي من البطن . إذا تمزقت قناة فالوب , فسيؤدى هذا إلى ألم حاد. وإذا وجد نزيف غزير , ستصير المريضة شاحبة اللون وقد تصاب بالإغماء, وتنهار بالكامل . ومع الفحص المبكر للحمل عن طريق الموجات فوق الصوتية , يمكن تشخيص الكتير من حالات الحمل خارج الرحم قبل تطور الأعراض الإكلينيكة الخطيرة .ويمكن أن تظهر الموجات فوق الصوتية عدم وجود حمل داخل الرحم . وليس من السهل دائما تشخيص الحمل خارج الرحم ,ولابد أن يكون الطبيق متأكد من عدم وجود حمل داخل الرحم ."),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          "أحيانا لابد من فحص مستويات هرمون موجة الغدد التناسلية المشيمائية لعدد من الأيام لرؤية ما اذا كان مستوي الهرمون يزيد بشكل طبيعي أم لا ."),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text("للتواصل عبر الايميل admin@hamilguide.com")
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        "رب لا تذرني فردا وأنت خير الوارثين ",
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "يوصى الأطباء والعلماء فى الطب البديل مرضاهم بتناول كميات كبيرة من عصائر الفواكة والخضروات الطازجة والتى لم تمر بعمليات التصنيع حيث أن العناصر المصنعه لا تحتفظ بالمغذيات الموجودة فيها . المشروبات الساخنة هى البديل الأمن والأفضل صيفا وشتاءا .. ففى الشتاء يحلو الكلام واللقاء مع مشروب دافئ ممتع يمد الجسم بالطاقة والدفئ وفوائد أخرى كالفيتامينات والمعادن ومضادات الأكسدة ويسهل تحضيره فى البيت بتكلفة قليلة . ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "أكدت الدراسة أن احتساء السوائل الباردة يسهم فى تضييق الأوعية الدموية وشعيراتها الموجودة فى الأطراف 'لذراعيين والساقيين والأصابع 'وبالتالي يحدث تدفق فى الدم إلى الجسم الداخلى والأعضاء الداخلية مما يحدث الشعور بالدفئ . كما أنها تسبب إنكماش المعدة مما يقلل الشعور بالجوع ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "ألام الحمل , الصداع ",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "منذ أصبحت حاملا يصيبنى صداع رهيب , لماذا ؟ ",
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ],
                  ),
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: _launchURLGroub,
                    child: Text(
                      "للمزيد ...",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "أسماء ومعانيها..... ",
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "ادم  ",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Text(
                    "اسم علم مذكر ، له أصول شاميه وعربيه فهو اسم ابو الأنبياء سيدنا ادم عليه السلام ، ويقصد به الرجل المخلوق من التربة الحمراء أو الصلصال وهو لون أديم الأرض ويمكن ان يكون معناه اسمر ، أبو البشر ، ومعناه باللغة العبرية  أحمر أو انسان أو الجنس البشري . لقوله تعالي “إن مثل عيسى عند الله كمثل آدم خلقه من تراب ثم قال له كن فيكون  ” وتعني بأن الله عز وجل خلق الإنسان من الطين الأسود .",
                    style: TextStyle(color: Colors.amber, fontSize: 16),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "رزان  ",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Text(
                    "اسم رزان من الأسماء العربية المؤنّثة، ويكتب بفتح الراء، وهو مأخوذ من كلمة الرزانة،[٢] ويعني اسم رزان المرأة التي تتصف بالوقار، حيث تتصف بالرزانة عند الجلوس معها في مجلسها، كما وتتصف بالعفّة، واسم رزان هو المؤنث من رزين الذي يعنى الإنسان الذي يمتلك الحُلم والوقار، كما ويعني الثبات والسكون.[٣].",
                    style: TextStyle(color: Colors.amber, fontSize: 16),
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "حكم التسمية باسم رزان",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Text(
                    "لم يُذكَر مانع شرعي في تسمية الفتيات باسم رزان، ومعنى اسم رزان مأخوذ من التأني والرزانة[٤]وعدم العجلة مع الأناة والتثبّت، والدليل على مشروعية التسمية باسم رزان أن الإسلام حث على معناه الحسن الطيب إذ حث النبي عليه الصلاة والسلام على التأني وذلك في قوله: (أنهاكُم عما يُنبذُ في الدباءَ والنقيرَ والحنتمَ المُزفَّتَ وزاد ابن مُعاذ في حديثه عن أبيه قال: وقال رسولُ اللهِ صلى الله عليه وسلم للأشجِّ، أشجُّ عبْدِالقيسِ: إن فيكَ خصلتينِ يحبهُما اللهُ: الحلمُ والأناةُ).",
                    style: TextStyle(color: Colors.amber, fontSize: 16),
                  ),
                  Text(
                    "صفحة تطبيق دليل المرأة الحامل هى المكان الذى سيمكنك من التواصل مع المستخدمين الاخرين وقراءة التي تهمك من خلال فترة حملك ",
                    style: TextStyle(color: Colors.black54),
                  ),
                  Center(
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: _launchURL,
                      child: Text("من هنا "),
                    ),
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "أو من خلال الرابط التالى ..  ",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                      InkWell(
                        onTap: () {
                          _launchURL();
                        },
                        child: Text(
                          "دليل المرأه الحامل ",
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Column(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "أكثر 10 أسماء شعبية في العالم العربي ",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(getColorHexFromStr("#333333"))),
                      )
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "أسماء البنات",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "1. لمار",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "2. تالا",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "3. دانة/فريدة",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "4. فرح/ردينة",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "5. ريم",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "6. يارين",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "7. ليان",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "8. ريتال",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "9. هنا/جودي/ريماس",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "10. شهد/جوري/زهراء",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),

                  //==============================================

                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "أسماء الأولاد / الصبيان ",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "1. محمد",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "2. أحمد",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "3. ناجى",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "4. يوسف",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "5. عمر",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "6. علي",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "7. علي",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "8. عبدالله",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "9. ادم",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),
                  Row(
                    textDirection: TextDirection.rtl,
                    children: <Widget>[
                      Text(
                        "10. ياسين",
                        style: TextStyle(color: Colors.black54, fontSize: 20),
                      ),
                    ],
                  ),

                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Container(
                      color: Color(getColorHexFromStr("#FFFFFF")),
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(" دليل المرأة الحامل "),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

_launchURL() async {
  const url = 'https://www.facebook.com/HamilGuide/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURLGroub() async {
  const url2 = 'https://www.facebook.com/groups/hamilguide';
  if (await canLaunch(url2)) {
    await launch(url2);
  } else {
    throw 'Could not launch $url2';
  }
}
