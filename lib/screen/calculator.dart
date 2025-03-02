import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = true;

  //send data
  Future<void> sendDataToApi() async {
    final url = Uri.parse('http://13.49.49.224:8080/api/userInfo/addInfo');
    final Map<String, dynamic> requestBody = {
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
      'systolic': systolic,
      'diastolic': diastolic,
      'restingHeartRate': pulse,
      'infectionDate': DateTime.now().toIso8601String(),
      'durationDays': covidDuration,
      'covidInfectionSeverity': covidSeverity,
      'treatmentStatus': treatmentStatus,
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
      print('Failed to send data');
    }
  }

  //reset form
  void _resetForm() {
    setState(() {
      gender = 'MALE';
      age = 0;
      weight = 0.0;
      height = 0.0;
      systolic = 0.0;
      diastolic = 0.0;
      pulse = 0;
      covidSeverity = 'MILD';
      covidDuration = 0;
      treatmentStatus = 'NOT_HOSPITALIZED';
      complications = [];
    });
  }

  // Переменные для хранения введенных данных
  String gender = 'Мужской';
  int age = 0;
  double weight = 0.0;
  double height = 0.0;
  double systolic = 0.0;
  double diastolic = 0.0;
  int pulse = 0;
  String covidSeverity = 'Легкая';
  int covidDuration = 0;
  String treatmentStatus = '';
  List complications = [];
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Выбор пола
              DropdownButtonFormField<String>(
                value: gender,
                decoration: InputDecoration(labelText: 'Пол'),
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
                decoration: InputDecoration(labelText: 'Возраст'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  age = int.tryParse(value) ?? 0;
                },
              ),
              // Ввод веса
              TextFormField(
                decoration: InputDecoration(labelText: 'Вес (кг)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  weight = double.tryParse(value) ?? 0.0;
                },
              ),
              // Ввод роста
              TextFormField(
                decoration: InputDecoration(labelText: 'Рост (см)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  height = double.tryParse(value) ?? 0.0;
                },
              ),
              // Ввод систолического давления
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Систолическое давление (мм рт.ст.)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  systolic = double.tryParse(value) ?? 0.0;
                },
              ),
              // Ввод диастолического давления
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Диастолическое давление (мм рт.ст.)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  diastolic = double.tryParse(value) ?? 0.0;
                },
              ),
              // Ввод пульса
              TextFormField(
                decoration:
                    InputDecoration(labelText: 'Пульс в покое (уд/мин)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  pulse = int.tryParse(value) ?? 0;
                },
              ),
              // Выбор тяжести COVID-19
              DropdownButtonFormField<String>(
                value: covidSeverity,
                decoration: InputDecoration(
                    labelText: 'Тяжесть перенесенного COVID-19'),
                items: ['Легкая', 'Средняя', 'Тяжелая']
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    covidSeverity = value!;
                  });
                },
              ),
              // Ввод длительности COVID-19 (в неделях)
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Длительность COVID-19 (недели)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  covidDuration = int.tryParse(value) ?? 0;
                },
              ),
              // Дополнительно можно добавить поля для постковидных осложнений и основного заболевания

              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Рассчитать'),
                onPressed: () {
                  // Если потребуется, можно добавить валидацию _formKey.currentState.validate();
                  String result = determineLoadLevel();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Результат'),
                      content: Text(result),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('OK'),
                        )
                      ],
                    ),
                  );
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
