import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

//listlar

  List yengil = [
    "одышка в покое",
    "головокружение",
    "головная боль",
    "слабость",
    "нарушение пищеварения"
  ];
  List orta = [
    "одышка при нагрузке",
    "периодическая слабость",
    "не частые головные боли"
  ];
  List ogir = ["редкие эпизоды слабости"];

  List zab2 = [
    "одышка в покое",
    "головокружение",
    "головная боль",
    "слабость",
    "нарушение пищеварения"
  ];

  //send data
  Future<void> sendDataToApi() async {
    final url = Uri.parse('http://13.49.49.224:8080/api/userInfo/addInfo');
    final Map<String, dynamic> requestBody = {
      'gender': gender == "Мужской" ? 'MALE' : 'FEMALE',
      'age': age,
      'weight': weight.toInt(),
      'height': height.toInt(),
      'physicalCondition': "GOOD",
      'systolic': systolic,
      'diastolic': diastolic,
      'restingHeartRate': pulse,
      // 'infectionDate': DateTime.now().toIso8601String(),
      'durationDays': covidDuration,
      'covidInfectionSeverity': zabolivaniya == "Легкая"
          ? "MILD"
          : zabolivaniya == "Средняя"
              ? "MODERATE"
              : "SEVERE",
      'treatmentStatus': 'NOT_HOSPITALIZED',
      'complications': complications,
    };

    String? token = await getToken();

    if (token == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print('Data successfully sent');
      _resetForm();
    } else {
      print(response.statusCode);
      print('Failed to send data');
    }
  }

  //reset form
  void _resetForm() {
    setState(() {
      gender = 'Мужской';
      age = 0;
      weight = 0.0;
      height = 0.0;
      systolic = 0.0;
      diastolic = 0.0;
      pulse = 0;
      covidSeverity = 'Легкая';
      covidDuration = 0;
      treatmentStatus = 'NOT_HOSPITALIZED';
      complications = [];
    });
  }

  // Переменные для хранения введенных данных
  String gender = 'Мужской';
  String zabolivaniya = 'одышка в покое';
  int age = 0;
  double weight = 0.0;
  double height = 0.0;
  double systolic = 0.0;
  double diastolic = 0.0;
  int pulse = 0;
  String covidSeverity = 'Легкая';
  int covidDuration = 0;
  String treatmentStatus = '';
  String osnZabolivaniya = '';
  List complications = [];
  String postCovidniyOslojeniya = 'Легкая';

  // Можно добавить поля для постковидных осложнений и основного заболевания

  /// Функция для расчета индекса массы тела (ИМТ)
  double calculateBMI() {
    if (height > 0) {
      // height предполагается в сантиметрах, переводим в метры
      double heightMeters = height / 100;
      return weight / (heightMeters * heightMeters);
    }
    return 0.0;
  }

  /// Функция, определяющая уровень нагрузки по введенным данным
  String determineLoadLevel() {
    double bmi = calculateBMI();

    // Примерная логика определения (данная логика – пример, её можно доработать согласно ТЗ)
    if (age > 60 ||
        bmi >= 30.0 ||
        bmi <= 18.5 ||
        systolic > 140.0 ||
        systolic < 100.0 ||
        diastolic > 90.0 ||
        diastolic < 60.0 ||
        pulse > 90 ||
        pulse < 50 ||
        (covidSeverity == 'Тяжелая' && covidDuration > 4)) {
      return 'Лёгкий уровень нагрузки';
    } else if (age < 60 &&
        ((bmi >= 25.0 && bmi <= 29.9) || (bmi >= 18.5 && bmi <= 24.9)) &&
        systolic >= 120.0 &&
        systolic <= 139.0 &&
        diastolic >= 80.0 &&
        diastolic <= 89.0 &&
        pulse >= 60 &&
        pulse <= 90 &&
        (covidSeverity == 'Средняя' &&
            covidDuration >= 2 &&
            covidDuration <= 4)) {
      return 'Средний уровень нагрузки';
    } else if (age < 60 &&
        (bmi >= 18.5 && bmi <= 24.9) &&
        systolic >= 110.0 &&
        systolic <= 120.0 &&
        diastolic >= 70.0 &&
        diastolic <= 80.0 &&
        pulse >= 60 &&
        pulse <= 80 &&
        (covidSeverity == 'Легкая' && covidDuration <= 2)) {
      return 'Продвинутый уровень нагрузки';
    } else {
      return 'Требуется дополнительная оценка';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Калькулятор Реабилитации'),
        backgroundColor: Colors.blueAccent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Text("Пол"),
              // Выбор пола
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(
                    labelText: 'Пол',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9))),
                items: ['Мужской', 'Женский']
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    gender = value!;
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              // DropdownButtonFormField<String>(
              //   value: gender,
              //   decoration: InputDecoration(labelText: 'Возраст'),
              //   items: ['Старше 60 лет', 'Младше 60 лет']
              //       .map((value) => DropdownMenuItem(
              //             value: value,
              //             child: Text(value),
              //           ))
              //       .toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       gender = value!;
              //     });
              //   },
              // ),
              // Ввод возраста
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Возраст',
                    counterText: '',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(9))),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                maxLength: 3,
                onChanged: (value) {
                  age = int.tryParse(value) ?? 0;
                },
              ),
              SizedBox(
                height: 10,
              ),
              // Ввод веса
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Вес (кг)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 3,
                      onChanged: (value) {
                        weight = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ),
                  SizedBox(width: 10), // Ikkita input orasida masofa qo‘shish
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Рост (см)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        counterText: '',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      maxLength: 3,
                      onChanged: (value) {
                        height = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Ввод систолического давления
              // Text("Артериальное давление"),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Systolic',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        systolic = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ),
                  SizedBox(width: 10), // Ikkita input orasida masofa qo‘shish
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Diastolic',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        diastolic = double.tryParse(value) ?? 0.0;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              // Ввод пульса
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Пульс в покое (уд/мин)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  pulse = int.tryParse(value) ?? 0;
                },
              ),
              SizedBox(
                height: 10,
              ),
              // Выбор тяжести COVID-19
              DropdownButtonFormField<String>(
                value: covidSeverity,
                decoration: InputDecoration(
                  labelText: 'Тяжесть перенесенного COVID-19',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                items: ['Легкая', 'Средняя', 'Тяжелая']
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    covidSeverity = value!;
                    covidSeverity == "Легкая"
                        ? zabolivaniya = "одышка в покое"
                        : covidSeverity == "Средняя"
                            ? zabolivaniya = "одышка при нагрузке"
                            : zabolivaniya = "редкие эпизоды слабости";
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              // Ввод длительности COVID-19 (в неделях)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Длительность COVID-19 (недели)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  covidDuration = int.tryParse(value) ?? 0;
                },
              ),
              SizedBox(
                height: 10,
              ),
              zabolivaniya == "одышка в покое"
                  ? DropdownButtonFormField<String>(
                      value: zabolivaniya,
                      decoration: InputDecoration(
                          labelText: 'Постковидное осложнение',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(9))),
                      items: [
                        "одышка в покое",
                        "головокружение",
                        "головная боль",
                        "слабость",
                        "нарушение пищеварения"
                      ]
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          zabolivaniya = value!;
                        });
                      },
                    )
                  : zabolivaniya == 'одышка при нагрузке'
                      ? DropdownButtonFormField<String>(
                          value: zabolivaniya,
                          decoration: InputDecoration(
                              labelText: 'Постковидное осложнение',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9))),
                          items: [
                            "одышка при нагрузке",
                            "периодическая слабость",
                            "не частые головные боли"
                          ]
                              .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              zabolivaniya = value!;
                            });
                          },
                        )
                      : DropdownButtonFormField<String>(
                          value: zabolivaniya,
                          decoration: InputDecoration(
                              labelText: 'Постковидное осложнение',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(9))),
                          items: ["редкие эпизоды слабости"]
                              .map((value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              zabolivaniya = value!;
                            });
                          },
                        ),
              SizedBox(
                height: 10,
              ),
              // Ввод длительности COVID-19 (в неделях)
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Основное заболевание',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  complications = [value] ?? [""];
                },
              ),
              SizedBox(
                height: 10,
              ),

              // Дополнительно можно добавить поля для постковидных осложнений и основного заболевания
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Рассчитать'),
                onPressed: () async {
                  // Если потребуется, можно добавить валидацию _formKey.currentState.validate();
                  // String result = determineLoadLevel();
                  await sendDataToApi().then(
                    (value) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Результат'),
                          content: Text("result"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('OK'),
                            )
                          ],
                        ),
                      );
                    },
                  );
                  // showDialog(
                  //   context: context,
                  //   builder: (context) => AlertDialog(
                  //     title: Text('Результат'),
                  //     content: Text(result),
                  //     actions: [
                  //       TextButton(
                  //         onPressed: () => Navigator.pop(context),
                  //         child: Text('OK'),
                  //       )
                  //     ],
                  //   ),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<String?> getToken() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("token");
}
