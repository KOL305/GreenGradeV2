import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
//\import 'package:path_provider/path_provider.dart';
//import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'HomePage.dart';
import 'SIIGEMINI.dart';
import 'SIILandingPage.dart';
//import 'QRCodeCompressor.dart';

import 'package:google_generative_ai/google_generative_ai.dart';

typedef PrintArrayC = Void Function(Array<Double>, Int32);
typedef PrintArrayDart = void Function(Array<Double>, int);
// Access your API key as an environment variable (see "Set up your API key" above)
const String apiKey = "AIzaSyCHqMM4qKAh-kDGL6Ty4bf2LR8PVS53CGM";

void main() {
  // print('API Key: $apiKey');
  // fetchGeminiData();

  runApp(GEMINICALCULATOR());
}

class GEMINICALCULATOR extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Owners'),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    Hive.openBox('SII');
    super.initState();
  }

  // Define controllers for each text field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController _totalWaterWithdrawalMinController =
      TextEditingController();
  final TextEditingController _totalWaterWithdrawalMaxController =
      TextEditingController();
  final TextEditingController _dischargedWaterMinController =
      TextEditingController();
  final TextEditingController _dischargedWaterMaxController =
      TextEditingController();
  final TextEditingController _reusedWaterMinController =
      TextEditingController();
  final TextEditingController _reusedWaterMaxController =
      TextEditingController();
  final TextEditingController _reductionFreshwaterMinController =
      TextEditingController();
  final TextEditingController _reductionFreshwaterMaxController =
      TextEditingController();
  final TextEditingController _ghgEmissionsMinController =
      TextEditingController();
  final TextEditingController _ghgEmissionsMaxController =
      TextEditingController();
  final TextEditingController _airEmissionsMinController =
      TextEditingController();
  final TextEditingController _airEmissionsMaxController =
      TextEditingController();
  final TextEditingController _reductionGhgMinController =
      TextEditingController();
  final TextEditingController _reductionGhgMaxController =
      TextEditingController();
  final TextEditingController _energyNonrenewableMinController =
      TextEditingController();
  final TextEditingController _energyNonrenewableMaxController =
      TextEditingController();
  final TextEditingController _energyRenewableMinController =
      TextEditingController();
  final TextEditingController _energyRenewableMaxController =
      TextEditingController();
  final TextEditingController _totalWasteGeneratedMinController =
      TextEditingController();
  final TextEditingController _totalWasteGeneratedMaxController =
      TextEditingController();
  final TextEditingController _wasteRecycledMinController =
      TextEditingController();
  final TextEditingController _wasteRecycledMaxController =
      TextEditingController();
  final TextEditingController _hazardousWasteMinController =
      TextEditingController();
  final TextEditingController _hazardousWasteMaxController =
      TextEditingController();
  final TextEditingController _debtEquityRatioMinController =
      TextEditingController();
  final TextEditingController _debtEquityRatioMaxController =
      TextEditingController();
  final TextEditingController _medianSalaryMinController =
      TextEditingController();
  final TextEditingController _medianSalaryMaxController =
      TextEditingController();
  final TextEditingController _marketCapMinController = TextEditingController();
  final TextEditingController _marketCapMaxController = TextEditingController();
  final TextEditingController _freshwaterConsumptionMinController =
      TextEditingController();
  final TextEditingController _freshwaterConsumptionMaxController =
      TextEditingController();
  final TextEditingController _numberOfEmployeesMinController =
      TextEditingController();
  final TextEditingController _numberOfEmployeesMaxController =
      TextEditingController();

  void _clearFields() {
    _totalWaterWithdrawalMinController.clear();
    _totalWaterWithdrawalMaxController.clear();
    _dischargedWaterMinController.clear();
    _dischargedWaterMaxController.clear();
    _reusedWaterMinController.clear();
    _reusedWaterMaxController.clear();
    _reductionFreshwaterMinController.clear();
    _reductionFreshwaterMaxController.clear();
    _ghgEmissionsMinController.clear();
    _ghgEmissionsMaxController.clear();
    _airEmissionsMinController.clear();
    _airEmissionsMaxController.clear();
    _reductionGhgMinController.clear();
    _reductionGhgMaxController.clear();
    _energyNonrenewableMinController.clear();
    _energyNonrenewableMaxController.clear();
    _energyRenewableMinController.clear();
    _energyRenewableMaxController.clear();
    _totalWasteGeneratedMinController.clear();
    _totalWasteGeneratedMaxController.clear();
    _wasteRecycledMinController.clear();
    _wasteRecycledMaxController.clear();
    _hazardousWasteMinController.clear();
    _hazardousWasteMaxController.clear();
    _debtEquityRatioMinController.clear();
    _debtEquityRatioMaxController.clear();
    _medianSalaryMinController.clear();
    _medianSalaryMaxController.clear();
    _marketCapMinController.clear();
    _marketCapMaxController.clear();
    _freshwaterConsumptionMinController.clear();
    _freshwaterConsumptionMaxController.clear();
    _numberOfEmployeesMinController.clear();
    _numberOfEmployeesMaxController.clear();
  }

  double minVal = -1;
  double maxVal = -1;
  String analysisT = "";
  bool isNameEmpty = true;

  void _addCompany() async {
    var box = Hive.box('SII');
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String key = timestamp.toString(); // Use the current length as the new key
    await box.put(key, {
      "name": nameController.text,
      "siiMin": minVal,
      "siiMax": maxVal,
      "analysisT": analysisT
    }); // Add a new entry
  }

  void _validateAndSubmit() {
    // print("running");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Processing..."),
        backgroundColor: Colors.blue,
      ),
    );
    // Helper function to check if max is less than min
    bool isValid = true;
    String errorMessage = '';

    bool checkMinMax(TextEditingController minController,
        TextEditingController maxController) {
      if (minController.text.isEmpty || maxController.text.isEmpty)
        return true; // Skip empty fields

      final double? minValue = double.tryParse(minController.text);
      final double? maxValue = double.tryParse(maxController.text);

      if (minValue == null || maxValue == null || maxValue < minValue) {
        isValid = false;
        return false;
      }
      return true;
    }

    // print("running");
    bool checkEmpty(TextEditingController minController,
        TextEditingController maxController) {
      if (minController.text.isEmpty || maxController.text.isEmpty) {
        return false;
      }
      return true;
    }

    // print("running");
    // Validate each pair of min and max fields
    if (!checkMinMax(_totalWaterWithdrawalMinController,
            _totalWaterWithdrawalMaxController) ||
        !checkMinMax(
            _dischargedWaterMinController, _dischargedWaterMaxController) ||
        !checkMinMax(_reusedWaterMinController, _reusedWaterMaxController) ||
        !checkMinMax(
            _reductionFreshwaterMinController, _reductionFreshwaterMaxController) ||
        !checkMinMax(_ghgEmissionsMinController, _ghgEmissionsMaxController) ||
        !checkMinMax(_airEmissionsMinController, _airEmissionsMaxController) ||
        !checkMinMax(_reductionGhgMinController, _reductionGhgMaxController) ||
        !checkMinMax(
            _energyNonrenewableMinController, _energyNonrenewableMaxController) ||
        !checkMinMax(
            _energyRenewableMinController, _energyRenewableMaxController) ||
        !checkMinMax(
            _totalWasteGeneratedMinController, _totalWasteGeneratedMaxController) ||
        !checkMinMax(
            _wasteRecycledMinController, _wasteRecycledMaxController) ||
        !checkMinMax(
            _hazardousWasteMinController, _hazardousWasteMaxController) ||
        !checkMinMax(
            _debtEquityRatioMinController, _debtEquityRatioMaxController) ||
        !checkMinMax(_medianSalaryMinController, _medianSalaryMaxController) ||
        !checkMinMax(_marketCapMinController, _marketCapMaxController) ||
        !checkMinMax(_freshwaterConsumptionMinController,
            _freshwaterConsumptionMaxController) ||
        !checkMinMax(
            _numberOfEmployeesMinController, _numberOfEmployeesMaxController)) {
      setState(() {
        errorMessage =
            'Max value should be greater than or equal to Min value for all fields.';
      });
    } else {
      setState(() {
        errorMessage = '';
      });
      // Handle submission logic here
    }
    if (!checkEmpty(_totalWaterWithdrawalMinController,
            _totalWaterWithdrawalMaxController) ||
        !checkEmpty(
            _dischargedWaterMinController, _dischargedWaterMaxController) ||
        !checkEmpty(_reusedWaterMinController, _reusedWaterMaxController) ||
        !checkEmpty(
            _reductionFreshwaterMinController, _reductionFreshwaterMaxController) ||
        !checkEmpty(_ghgEmissionsMinController, _ghgEmissionsMaxController) ||
        !checkEmpty(_airEmissionsMinController, _airEmissionsMaxController) ||
        !checkEmpty(_reductionGhgMinController, _reductionGhgMaxController) ||
        !checkEmpty(
            _energyNonrenewableMinController, _energyNonrenewableMaxController) ||
        !checkEmpty(
            _energyRenewableMinController, _energyRenewableMaxController) ||
        !checkEmpty(
            _totalWasteGeneratedMinController, _totalWasteGeneratedMaxController) ||
        !checkEmpty(_wasteRecycledMinController, _wasteRecycledMaxController) ||
        !checkEmpty(
            _hazardousWasteMinController, _hazardousWasteMaxController) ||
        !checkEmpty(
            _debtEquityRatioMinController, _debtEquityRatioMaxController) ||
        !checkEmpty(_medianSalaryMinController, _medianSalaryMaxController) ||
        !checkEmpty(_marketCapMinController, _marketCapMaxController) ||
        !checkEmpty(_freshwaterConsumptionMinController,
            _freshwaterConsumptionMaxController) ||
        !checkEmpty(
            _numberOfEmployeesMinController, _numberOfEmployeesMaxController)) {
      setState(() {
        errorMessage = 'All fields must be populated.';
      });
    }
    // print("running");
    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      setIndicatorVals();
      callCFunction();
      analyzeCompany();
      //save to hive
      //navigate to sii finish page

      //submission logic
      // print("running");
    }
  }

  void analyzeCompany() async {
    final modeltwo = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    final contenttwo = [
      Content.text(
          'The attached files are used in a Sustainability Interval Index calculator, which assesses the sustainability of a company based on a set of Base Indicators. The Base indicators are located in a 1D array (list). Each indicator is ordered so that the lower bound comes first, and then the upper bound. After the indicator has both bounds, it repeats with the next indicator. If their bounds are identical, that means we have an exact number for that category. All of these are related to sustainability. The array also returns the final interval of sustainability for the company (derived by the SII calculator) as a lower and upper bound. The lower and upper bounds will be located as the final elements of the list (elements 31-32). Again, it is important to remember that THE SII INTERVAL IS LOCATED AT THE END OF THE LIST and gives the overall sustainability of the company as an interval. The categories are as follows: \n\nTotal Water Withdrawal (elements 1-2): cubic meters of water per year per employee\nDischarged Water (elements 3-4): cubic meters of water per year per employee\nReused or Treated Water (elements 5-6): percentage of total water use\nReduction in Freshwater Consumption (elements 7-8): percentage reduced per year\nGHG Emissions (elements 9-10): kilograms of carbon dioxide equivalent per employee\nAir Emissions (elements 11-12): tons of pollutants per employee\nReduction in GHG (elements 13-14): percentage reduced per year\nEnergy From Nonrenewable Sources (elements 15-16): joules per employee\nEnergy From Renewable Sources (elements 17-18): percentage of total energy use\nTotal Waste Generated (elements 19-20): tons per year normalized to employees\nWaste Recycled (elements 21-22): tons per year normalized to employees\nHazardous Waste (elements 23-24): tons per year normalized to employees\nDebt Ratio to equity (elements 25-26)\nSalary (elements 27-28): US dollars per year\nMarket Capitalization per Employee (elements 29-30): single US dollars per employee\nSII (elements 31-32)\n\nNote: if a reduction rate is negative, that means the use of such resources is INCREASING.\n\nThe Sustainability calculator returns and interval of sustainability for a company as a lower and upper bound. The lower and upper bound will be located as the final elements of the list (elements 31-32). \n\nGiven the final SII and additional information, please identify the significance of the company’s sustainability in these areas. Each area should be its own paragraph. Find a number of contemporaries in its industry and compare the company’s sustainability to theirs but do not fabricate SII values for other companies. Describe the significance of the range of the SII interval and BIint intervals for all the below points. Ensure you have thoroughly examined ALL data within the BIints file before moving on to other information sources. \n\nGlobal Influence: MAKE A STATEMENT ON WHETHER OR NOT THE COMPANY IS SUSTAINABLE. The benchmark for sustainability should be around 0.7. Supplement the following information with data from the internet. Check if the company’s sustainability initiatives align with existing societal sustainability goals. Compare its sustainability with the sustainability of other companies in its industry by extrapolating data found online and determining its comparative performance. Compare the goals of internal sustainability initiatives found on its website and sustainability reports to the current SII and Basic Indicators of the company, and evaluate if the company is meeting its own goals. Do not highlight specific areas in this section, but rather the overall sustainability of the company. \n\nEconomics: Describe the economic ramifications of the company’s SII. Go onto the internet to find the economic state of the company and how the following relates to it. Describe the impact of the company’s sustainability on its investment risk, growth, reputation, and other important factors. The relative impact of their sustainability would depend on their particular industry. For instance, a mining company might be sustainable by industry standards but still have a higher absolute environmental impact than a biotech company. However, in terms of investment risk, the mining company might still be a good investment if it is managing its sustainability challenges effectively relative to its peers. It is crucial that AI is able to differentiate industry standards when evaluating risk. \n\nLegal Risks: Companies that are not sustainable are more at risk for litigation for failing to meet regulatory standards and will struggle to comply with future environmental regulations. Highlight potential failures in company sustainability policy. In addition, describe future sustainability policies that the company may fail to meet. Be specific, use the internet to find examples of policies in the process of gaining approval. Again, legal risks are relative. One industry may be significantly more at risk than another, even if they are more sustainable. Also, account for how one sustainability metric may be more significant than the other. \n\nLastly, analyze 4 indicators that the company could most improve and discuss their significance. Explain why you chose these indicators and ALWAYS HIGHLIGHT SPECIFIC DATA POINTS for these indicators. Do not cite the row number. DO NOT USE BULLET POINTS. Include improvements that the company could make to increase its sustainability. \n\nFinally, include a conclusion summarizing your findings. \n\nTime: take as much time as necessary to accomplish your task.\nTone: Professional. Avoid language that may result in litigation.\n\n$indicatorVals\n\nSII Min: $minVal\nSII Max: $maxVal')
    ];
    var an = await modeltwo.generateContent(contenttwo);
    analysisT = an.text!;
    //print(analysisT);
    _addCompany();
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SIIGEMINI(
              nameCompany: nameController.text,
              min: minVal,
              max: maxVal,
              analysisText: analysisT),
        ));
  }

  List<double> arrStringToDoub(List<String> arr) {
    List<double> returnArr = [];
    for (int i = 0; i < arr.length; i++) {
      returnArr.add(double.parse(arr[i]));
    }
    return returnArr;
  }

  //List<double> doubleIndicatorVals = [];
  void callCFunction() {
    // print("running");
    final DynamicLibrary nativeLib = Platform.isAndroid
        ? DynamicLibrary.open('libexample.so')
        : DynamicLibrary.process();
    // test array, u will have to use the one from gemini

    List<double> doubleIndicatorVals = arrStringToDoub(indicatorVals);

    // print(doubleIndicatorVals.length);

    // Allocate memory for the array in native memory
    Pointer<Double> nativeArray = malloc<Double>(doubleIndicatorVals.length);

    // Copy Dart array to native memory
    for (int i = 0; i < doubleIndicatorVals.length; i++) {
      nativeArray[i] = doubleIndicatorVals[i];
    }

    // for (int i = 0; i < dartArray.length; i++) {
    // print(nativeArray[i]);
    // }

    // tbh u cud skip this step if its already stored as a pointer, but use this if not\

    for (int i = 0; i < doubleIndicatorVals.length; i++) {
      // print("real");
      // print(doubleIndicatorVals[i]);

      // print("string");
      // print(indicatorVals[i]);

      // print("native");
      // print(nativeArray[i]);
    }

    // final setNumbers = nativeLib.lookupFunction<Void Function(Pointer<Double>),
    //     void Function(Pointer<Double>)>("correctInputs");

    // setNumbers(nativeArray);

    // final getBIints = nativeLib.lookupFunction<Pointer<Utf8> Function(),
    //     Pointer<Utf8> Function()>("getBIintsConst");
    // final getActual = nativeLib.lookupFunction<Pointer<Utf8> Function(),
    //     Pointer<Utf8> Function()>("getActualIntsConst");

    // print(getBIints().toDartString());
    // print("done with i ints");
    // print(getActual().toDartString());
    final real =
        nativeLib.lookupFunction<Int32 Function(Pointer<Double>), int Function(Pointer<Double>)>("real");
    real(nativeArray);
    final getMin = nativeLib
        .lookupFunction<Double Function(), double Function()>("getMin");

    final getMax = nativeLib
        .lookupFunction<Double Function(), double Function()>("getMax");
    minVal = getMin();
    maxVal = getMax();
    // print("min");
    // print(getMin());
    // print("max");
    // print(getMax());

    malloc.free(nativeArray);
  }

  String text = "";
  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load('assets/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  String? _fileName;
  String? _filePath;
  void _pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Uploading File..."),
          backgroundColor: Colors.blue,
        ),
      );
      final file = result.files.first;

      setState(() {
        _fileName = file.name;
        _filePath = file.path;
      });
      print(_fileName);
      print(_filePath);

      File pdfFile = File(_filePath!);
      List<int> bytes = await pdfFile.readAsBytes();
      PdfDocument document = PdfDocument(inputBytes: bytes);
      //Create a new instance of the PdfTextExtractor.
      PdfTextExtractor extractor = PdfTextExtractor(document);

      //Extract all the text from the document.
      text = extractor.extractText();

      // You can access the file path using file.path
      // File fileToUpload = File(file.path!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("File Uploaded!"),
          backgroundColor: Colors.blue,
        ),
      );
    } else {
      // User canceled the picker
    }
  }

  List<String> indicatorVals = [];

  void setIndicatorVals() async {
    double numEmployees = (double.parse(_numberOfEmployeesMinController.text) +
            double.parse(_numberOfEmployeesMaxController.text)) /
        2;
    indicatorVals = [
      (double.parse(_totalWaterWithdrawalMinController.text) / numEmployees)
          .toString(),
      (double.parse(_totalWaterWithdrawalMaxController.text) / numEmployees)
          .toString(),
      (double.parse(_dischargedWaterMinController.text) / numEmployees)
          .toString(),
      (double.parse(_dischargedWaterMaxController.text) / numEmployees)
          .toString(),
      _reusedWaterMinController.text,
      _reusedWaterMaxController.text,
      _reductionFreshwaterMinController.text,
      _reductionFreshwaterMaxController.text,
      (double.parse(_ghgEmissionsMinController.text) / numEmployees).toString(),
      (double.parse(_ghgEmissionsMaxController.text) / numEmployees).toString(),
      (double.parse(_airEmissionsMinController.text) / numEmployees).toString(),
      (double.parse(_airEmissionsMaxController.text) / numEmployees).toString(),
      _reductionGhgMinController.text,
      _reductionGhgMaxController.text,
      (double.parse(_energyNonrenewableMinController.text) / numEmployees)
          .toString(),
      (double.parse(_energyNonrenewableMaxController.text) / numEmployees)
          .toString(),
      _energyRenewableMinController.text,
      _energyRenewableMaxController.text,
      (double.parse(_totalWasteGeneratedMinController.text) / numEmployees)
          .toString(),
      (double.parse(_totalWasteGeneratedMaxController.text) / numEmployees)
          .toString(),
      (double.parse(_wasteRecycledMinController.text) / numEmployees)
          .toString(),
      (double.parse(_wasteRecycledMaxController.text) / numEmployees)
          .toString(),
      (double.parse(_hazardousWasteMinController.text) / numEmployees)
          .toString(),
      (double.parse(_hazardousWasteMaxController.text) / numEmployees)
          .toString(),
      _debtEquityRatioMinController.text,
      _debtEquityRatioMaxController.text,
      _medianSalaryMinController.text,
      _medianSalaryMaxController.text,
      (double.parse(_marketCapMinController.text) / numEmployees).toString(),
      (double.parse(_marketCapMaxController.text) / numEmployees).toString(),
      (double.parse(_freshwaterConsumptionMinController.text) / numEmployees)
          .toString(),
      (double.parse(_freshwaterConsumptionMaxController.text) / numEmployees)
          .toString()
    ];

    print("runningdd");
  }

  void setValidator(valid) {
    setState(() {
      isNameEmpty = valid;
    });
  }

  void _findIndicatorVals() async {
    if (nameController.text == '') {
      setValidator(false);
      return;
    } else {
      setValidator(true);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Finding Values..."),
        backgroundColor: Colors.blue,
      ),
    );
    print("running");
    if (apiKey == null) {
      print('No \$API_KEY environment variable');
      exit(1);
    }
    // The Gemini 1.5 models are versatile and work with both text-only and multimodal prompts
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    String company = nameController.text;
    final content = [
      Content.text(
          'Task: You are an expert in analyzing company sustainability reports. Your task is to find certain sustainability data for the company $company. I have provided a sustainability report, and you must extract and estimate specific sustainability indicators from the report and the Internet. Follow the detailed instructions below: 1. Data Extraction: Objective: Extract the following sustainability indicators. For each indicator, provide both the minimum and maximum values: If an exact value is available, use it for both min and max. If the indicator is not explicitly stated, estimate a reasonable range based on the report and other sources on the Internet as well as as company websites, industry averages, or financial databases. If the company is in the United states, use https://www.sec.gov/edgar/search/ to source financial information. Ensure all values are in the correct units. If needed, convert units accordingly. For market cap, look at stock exchanges exclusively as these will be most accurate. Indicators List: Total Water Withdrawal (m³/year) Discharged Water (m³/year) Reused or Treated Water (% of total water withdrawal) Reduction in Freshwater Consumption (%/year) GHG Emissions (kg CO₂ equivalent/year) Air Emissions (metric tons/year) Reduction in GHG (%/year) Energy From Nonrenewable Sources (Joules/year) Energy From Renewable Sources (% of total energy) Total Waste Generated (metric tons/year) Waste Recycled (metric tons/year) Hazardous Waste (metric tons/year) Debt Ratio to Equity Median Salary (USD/year) Market Capitalization (USD) Fresh Water Consumption (m³/year) Number of employees 2. Output Format: Structure: Provide the results in a 1D array with min and max values for each indicator in the same order as listed above. Formatting: Enclose all values in quotes and separate them with commas. The array should be enclosed in square brackets []. Ensure all values are in numerical format without scientific notation. Remove commas and other .on-numeric characters from the values The output must contain 34 values in total. Example Output (DO NOT COPY THIS): ["210.5", "210.5", "228.6", "228.6", "197.2", "214.5", "5", "1", "-11", "0", "15430", "16080", "0.02", "0.03", "-1", "4.4", "4.97", "9.41", "0", "100", "0.2", "0.22", "0.16", "0.18", "0.08", "0.09", "0.4", "0.8", "40000", "150000", "250000", "750000", "101010", "101010e"] 3. Estimation Guidelines: Prioritization: Always prioritize data within the report for estimations. External Sources: If data is missing, search for information on the Internet. This could be the company’s website, reputable financial databases, or industry reports. Benchmarks: For market capitalization, use comparable publicly traded companies as benchmarks. You should only output the array. Do this for the company apple.')
    ];

    var response = await model.generateContent(content);
    while (response.text!.split('", "').length != 34) {
      response = await model.generateContent(content);
    }
    print(response.text);

    List<String> indicators = response.text!.split('", "');
    indicators[0] = indicators[0].substring(2);
    print(indicators[33]);
    String str = indicators[33];
    str = str.split('"')[0];
    indicators[33] = str;
    print(str);
    print(indicators[33]);
    _totalWaterWithdrawalMinController.text = indicators[0];
    _totalWaterWithdrawalMaxController.text = indicators[1];
    _dischargedWaterMinController.text = indicators[2];
    _dischargedWaterMaxController.text = indicators[3];
    _reusedWaterMinController.text = indicators[4];
    _reusedWaterMaxController.text = indicators[5];
    _reductionFreshwaterMinController.text = indicators[6];
    _reductionFreshwaterMaxController.text = indicators[7];
    _ghgEmissionsMinController.text = indicators[8];
    _ghgEmissionsMaxController.text = indicators[9];
    _airEmissionsMinController.text = indicators[10];
    _airEmissionsMaxController.text = indicators[11];
    _reductionGhgMinController.text = indicators[12];
    _reductionGhgMaxController.text = indicators[13];
    _energyNonrenewableMinController.text = indicators[14];
    _energyNonrenewableMaxController.text = indicators[15];
    _energyRenewableMinController.text = indicators[16];
    _energyRenewableMaxController.text = indicators[17];
    _totalWasteGeneratedMinController.text = indicators[18];
    _totalWasteGeneratedMaxController.text = indicators[19];
    _wasteRecycledMinController.text = indicators[20];
    _wasteRecycledMaxController.text = indicators[21];
    _hazardousWasteMinController.text = indicators[22];
    _hazardousWasteMaxController.text = indicators[23];
    _debtEquityRatioMinController.text = indicators[24];
    _debtEquityRatioMaxController.text = indicators[25];
    _medianSalaryMinController.text = indicators[26];
    _medianSalaryMaxController.text = indicators[27];
    _marketCapMinController.text = indicators[28];
    _marketCapMaxController.text = indicators[29];
    _freshwaterConsumptionMinController.text = indicators[30];
    _freshwaterConsumptionMaxController.text = indicators[31];
    _numberOfEmployeesMinController.text = indicators[32];
    _numberOfEmployeesMaxController.text = indicators[33];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color(0xFF11221d), // Dark color to match the background
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Color(0xFF62ffac)),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              // Menu Icon at the top of the sidebar
              ListTile(
                leading: Icon(Icons.menu, color: Color(0xFF62ffac)),
              ),
              // Home option
              ListTile(
                title: Text(
                  'Home',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
              ),
              // Sustainability Interval Calculator option
              ListTile(
                title: Text(
                  'Sustainability Interval Company View',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SIILandingPage(
                            title: 'Sustainability Interval Index')),
                  );
                },
              ),
              // Gemini Index Generator option (now 3rd)
              ListTile(
                title: Text(
                  'Gemini Index Generator',
                  style: TextStyle(
                    color: Color(0xFF62ffac),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context); // Close drawer
                },
              ),
              // QR Code Compressor option
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF11221d), Color(0xFF000000)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Divider(
                        color: Color(0xFF62ffac),
                        thickness: 2,
                        endIndent: 10,
                      ),
                    ),
                    Text(
                      'Gemini Input Form',
                      style: TextStyle(
                        color: Color(0xFF62ffac),
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Divider(
                        color: Color(0xFF62ffac),
                        thickness: 2,
                        indent: 10,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'Upload sustainability or ESG report for desired company. Or just manually type in the data.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 13),
                Container(
                  padding: EdgeInsets.all(5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: _pickPDF,
                        child: const Text('Upload PDF',
                            style: TextStyle(
                              color: Color(0xFF11221d),
                            )),
                      ),
                      SizedBox(height: 12),
                      TextField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: nameController,
                          decoration: InputDecoration(
                              labelText: "Company Name",
                              labelStyle: TextStyle(
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(),
                              errorText: isNameEmpty
                                  ? null
                                  : "Please enter a company name in order to continue.",
                              errorStyle: TextStyle(color: Colors.white),
                              focusedErrorBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              errorBorder: UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.white)))),
                    ],
                  ),
                ),
                SizedBox(height: 9),
                Container(

                    //padding: EdgeInsets.top(5),
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              _findIndicatorVals();
                            },
                            child: const Text('Find Indicator Values',
                                style: TextStyle(
                                  color: Color(0xff11221d),
                                )),
                          ),
                          // SizedBox(width:10),
                          // !finding ? Text(
                          //       "Please Wait...",
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 16,
                          //       ),
                          //     ) : const Text(""),
                        ])),
                SizedBox(height: 17),
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFFFFF), Color(0xFF62ffac)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Indicator Input Form',
                        style: TextStyle(
                          color: Color(0xFF0b1411),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
                      inputField(
                          "Total Water Withdrawal",
                          "Cubic Meters",
                          _totalWaterWithdrawalMinController,
                          _totalWaterWithdrawalMaxController,
                          '',
                          ''),
                      inputField(
                          "Discharged Water",
                          "Cubic Meters",
                          _dischargedWaterMinController,
                          _dischargedWaterMaxController,
                          '',
                          ''),
                      inputField(
                          "Reused or Treated Water",
                          "% of Total Water Use",
                          _reusedWaterMinController,
                          _reusedWaterMaxController,
                          '',
                          ''),
                      inputField(
                          "Reduction in Freshwater Consumption",
                          "% Reduction",
                          _reductionFreshwaterMinController,
                          _reductionFreshwaterMaxController,
                          '',
                          ''),
                      inputField(
                          "GHG Emissions",
                          "Kg CO2 Equivalent",
                          _ghgEmissionsMinController,
                          _ghgEmissionsMaxController,
                          '',
                          ''),
                      inputField(
                          "Air Emissions",
                          "Metric Tons",
                          _airEmissionsMinController,
                          _airEmissionsMaxController,
                          '',
                          ''),
                      inputField(
                          "Reduction in GHG",
                          "% Reduction",
                          _reductionGhgMinController,
                          _reductionGhgMaxController,
                          '',
                          ''),
                      inputField(
                          "Energy from Nonrenewable Sources",
                          "Joules",
                          _energyNonrenewableMinController,
                          _energyNonrenewableMaxController,
                          '',
                          ''),
                      inputField(
                          "Energy from Renewable Sources",
                          "% Total Energy Use",
                          _energyRenewableMinController,
                          _energyRenewableMaxController,
                          '',
                          ''),
                      inputField(
                          "Total Waste Generated",
                          "Metric Tons",
                          _totalWasteGeneratedMinController,
                          _totalWasteGeneratedMaxController,
                          '',
                          ''),
                      inputField(
                          "Waste Recycled",
                          "Metric Tons",
                          _wasteRecycledMinController,
                          _wasteRecycledMaxController,
                          '',
                          ''),
                      inputField(
                          "Hazardous Waste",
                          "Metric Tons",
                          _hazardousWasteMinController,
                          _hazardousWasteMaxController,
                          '',
                          ''),
                      inputField(
                          "Debt to Equity Ratio",
                          "Units N/A",
                          _debtEquityRatioMinController,
                          _debtEquityRatioMaxController,
                          '',
                          ''),
                      inputField(
                          "Median Salary",
                          "USD",
                          _medianSalaryMinController,
                          _medianSalaryMaxController,
                          '',
                          ''),
                      inputField("Market Cap", "USD", _marketCapMinController,
                          _marketCapMaxController, '', ''),
                      inputField(
                          "Freshwater Consumption",
                          "Cubic Meters",
                          _freshwaterConsumptionMinController,
                          _freshwaterConsumptionMaxController,
                          '',
                          ''),
                      inputField(
                          "Number of Employees",
                          "Units N/A",
                          _numberOfEmployeesMinController,
                          _numberOfEmployeesMaxController,
                          '',
                          ''),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: _clearFields,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF62ffac)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Clear Fields',
                        style: TextStyle(color: Color(0xFF62ffac)),
                      ),
                    ),
                    SizedBox(width: 20),
                    OutlinedButton(
                      onPressed: _validateAndSubmit,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF62ffac)),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Color(0xFF62ffac)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget inputField(
      String label,
      String unit,
      TextEditingController minController,
      TextEditingController? maxController,
      String inputA,
      String inputB) {
    minController.text = inputA;
    if (maxController != null) {
      maxController.text = inputB;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text('$label: $unit'),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: minController,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'-?\d*\.?\d*'))
                ],
                decoration: InputDecoration(
                  labelText: 'Min',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            maxController != null
                ? Expanded(
                    child: TextField(
                      controller: maxController,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'-?\d*\.?\d*'))
                      ],
                      decoration: InputDecoration(
                        labelText: 'Max',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  )
                : Container(), // If there's no max controller, don't show the max field
          ],
        ),
      ],
    );
  }
}


/* void test() async {
  // String  apiKey = String.fromEnvironment("API_KEY");
  print(apiKey);
  // Access your API key as an environment variable (see "Set up your API key" above)
  if (apiKey == null) {
    print('No \$API_KEY environment variable');
    exit(1);
  }
  // The Gemini 1.5 models are versatile and work with both text-only and multimodal prompts
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  //final content = [Content.text('Task: You are an expert in analyzing company sustainability reports. I have provided a sustainability report, and I need you to extract and estimate specific sustainability indicators from the report and the Internet. Follow the detailed instructions below: 1. Data Extraction: Objective: Extract the following sustainability indicators. For each indicator, provide both the minimum and maximum values: If an exact value is available, use it for both min and max. If the indicator is not explicitly stated, estimate a reasonable range based on the report and other sources on the Internet as well as as company websites, industry averages, or financial databases. Ensure all values are in the correct units. If needed, convert units accordingly. Indicators List: Total Water Withdrawal (m³/year) Discharged Water (m³/year) Reused or Treated Water (% of total water withdrawal) Reduction in Freshwater Consumption (%/year) GHG Emissions (kg CO₂ equivalent/year) Air Emissions (metric tons/year) Reduction in GHG (%/year) Energy From Nonrenewable Sources (Joules/year) Energy From Renewable Sources (% of total energy) Total Waste Generated (metric tons/year) Waste Recycled (metric tons/year) Hazardous Waste (metric tons/year) Debt Ratio to Equity Median Salary (USD/year) Market Capitalization (USD) Fresh Water Consumption (m³/year) Number of employees 2. Output Format: Structure: Provide the results in a 1D array with min and max values for each indicator in the same order as listed above. Formatting: Enclose all values in quotes and separate them with commas. If you got a value from the sustainability report, append the word Report to the value. If you got a value from the Internet, append the word Internet to the value. The array should be enclosed in square brackets []. Ensure all values are in numerical format without scientific notation. Remove commas from the values. The output must contain 34 values in total. Example Output (DO NOT COPY THIS): ["210.5Internet", "210.5Internet", "228.6Report", "228.6Report", "197.2Report", "214.5Report", "5Internet", "10Internet", "-11Report", "0Internet", "15430Report", "16080Internet", "0.02Report", "0.03Internet", "-1Report", "4.4Internet", "4.97Report", "9.41Internet", "0Report", "100Internet", "0.2Report", "0.22Internet", "0.16Report", "0.18Internet", "0.08Report", "0.09Internet", "0.4Report", "0.8Internet", "40000Report", "150000Internet", "250000Report", "750000Internet", "101010Report", "101010Report"] 3. Estimation Guidelines: Prioritization: Always prioritize data within the report for estimations. External Sources: If data is missing, search for information on the Internet. This could be the company’s website, reputable financial databases, or industry reports. Benchmarks: For market capitalization, use comparable publicly traded companies as benchmarks. You should only output the array. Do this for the company apple.')];
  final content = [
    Content.text(
        'Task: Output the following exactly as written:\n\n["234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234", "234"]')
  ];
  final response = await model.generateContent(content);
  // print(response.text);
} */


// Future<void> fetchGeminiData() async {
//   final response = await http.get(
//     Uri.parse('https://api.gemini.com/v1/some-endpoint'),
//     headers: {
//       'X-Gemini-APIKey': apiKey,  // Pass your API key here
//     },
//   );

//   if (response.statusCode == 200) {
//     // Process the data
//     print('Data: ${response.body}');
//   } else {
//     throw Exception('Failed to load data: ${response.statusCode}');
//   }
// }
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('FFI Example'),
//       ),
//       body: Column(
//         children: [
//           Center(
//             child: ElevatedButton(
//               onPressed: () {
//                 callCFunction();
//               },
//               child: Text('Call C++ Function'),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => QRScanner()));
//             },
//             child: Text('Open Scanner'),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void callCFunction() {
//   final DynamicLibrary nativeLib = Platform.isAndroid
//       ? DynamicLibrary.open('libexample.so')
//       : DynamicLibrary.process();
// // test array, u will have to use the one from gemini
// print("rannnd");
//   final List<double> dartArray =
//   [5932.772365,	5932.77236,
//   7673.782108,	7673.782108,
//   61.5,	61.5,
//   11.75942918,	11.75942918,
//   7670504.872,	7670504.872,
//   4609.911426,	4609.911426,
//   21.07362861,	21.07362861,
//   11248893000000,	11248893000000,
//   20.6,	20.6,
//   3222.763508,	3222.763508,
//   224.7121346,	224.7121346,
//   1018.689105,	1018.689105,
//   0.12,	0.12,
//   78944,	101624,
//   1211691.763,	1211691.763,
//   3333.215235, 3333.215235];

//  // Allocate memory for the array in native memory
//     final Pointer<Double> nativeArray = malloc<Double>(dartArray.length);

//     // Copy Dart array to native memory
//     for (int i = 0; i < dartArray.length; i++) {
//       nativeArray[i] = dartArray[i];
//     }

//     // for (int i = 0; i < dartArray.length; i++) {
//     // print(nativeArray[i]);
//     // }

//     // tbh u cud skip this step if its already stored as a pointer, but use this if not

//   final setNumbers = nativeLib.lookupFunction<Void Function(Pointer<Double>), void Function(Pointer<Double>)>("correctInputs");

//   setNumbers(nativeArray);

//   // final getBIints = nativeLib.lookupFunction<Pointer<Utf8> Function(), Pointer<Utf8> Function()>("getBIintsConst");
//   // final getActual = nativeLib.lookupFunction<Pointer<Utf8> Function(), Pointer<Utf8> Function()>("getActualIntsConst");

//   // print(getBIints().toDartString());
//   // print("done with i ints");
//   // print(getActual().toDartString());

//   final real =
//       nativeLib.lookupFunction<Int32 Function(), int Function()>("real");
//   real();

//   final getMin =
//       nativeLib.lookupFunction<Double Function(), double Function()>("getMin");

//   final getMax =
//       nativeLib.lookupFunction<Double Function(), double Function()>("getMax");

//   print(getMin());
//   print(getMax());
// }
