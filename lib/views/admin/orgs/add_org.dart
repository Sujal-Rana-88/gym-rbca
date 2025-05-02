import 'dart:async';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/url_constants.dart';

class AddOrgScreen extends StatefulWidget {
  final Map<String, String> formData;

  const AddOrgScreen({Key? key, required this.formData}) : super(key: key);

  @override
  _AddOrgScreenState createState() => _AddOrgScreenState();
}

class _AddOrgScreenState extends State<AddOrgScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;
  Timer? _debounce;

  final List<String> subscriptionOptions = ["3 Months", "6 Months", "1 Year"];
  bool wantsSubscription = false;
  final Dio _dio = Dio();

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget _buildTextField(String label, String key, {String? initialValue}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue ?? widget.formData[key],
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          if (key == "owner_email" && !EmailValidator.validate(value)) {
            return 'Enter a valid email address';
          }
          if (value.length > 50) {
            return '$label cannot exceed 50 characters';
          }
          return null;
        },
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce?.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            setState(() {
              widget.formData[key] = value;
            });
          });
        },
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final prefs = await SharedPreferences.getInstance();
      final String baseUrl = APPConstants.BASE_URL;
      final String addOrgEndpoint = URLConstants.addOrg;
      String? token = prefs.getString('accessToken');
      final Map<String, dynamic> requestData = {
        "organizationName": widget.formData["org_name"],
        "organizationAddress": widget.formData["address"],
        "organizationMobileNumber": widget.formData["phone"],
        "organizationCountryCode": widget.formData["country_code"],
        "organizationEmail": widget.formData["org_email"], // fixed
        "firstName": widget.formData["owner_first_name"],
        "lastName": widget.formData["owner_last_name"],
        "fatherName": widget.formData["father_name"],
        "userAddress": widget.formData["owner_address"],
        "userEmail": widget.formData["user_email"],
        "userCountryCode": widget.formData["owner_country_code"],
        "userMobileNumber": widget.formData["owner_phone"],
        "role": "owner",
        "organizationGstin": widget.formData["org_gstin"], // fixed
      };

      try {
        final response = await _dio.post(
          '$baseUrl$addOrgEndpoint',
          data: requestData,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
              "Content-Type": "application/json",
            },
          ),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Organization Added Successfully!")),
          );
          Navigator.pop(context);
        } else {
          print("API Error: ${response.statusCode}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    "Failed to add organization. Status code: ${response.statusCode}")),
          );
        }
      } catch (e) {
        print("Error submitting form: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("An error occurred while submitting the form")),
        );
      }
    }
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_currentStep < 2) {
        _pageController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        setState(() {
          _currentStep++;
        });
      } else {
        _submitForm(); // Call the submit function here
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(
                value: (_currentStep + 1) / 3,
                backgroundColor: Colors.grey[300],
                color: Colors.blueAccent),
            SizedBox(height: 8),
            Text("Step ${_currentStep + 1}/3",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTextField("Organization Name", "org_name"),
                          _buildTextField("Country Code", "country_code",
                              initialValue: "+91"),
                          _buildTextField(
                              "organization Mobile Number", "phone"),
                          _buildTextField("organization Email", "org_email"),
                          _buildTextField("organization Address", "address"),
                          _buildTextField("Org ID (CIN/GSTIN)", "org_gstin"),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildTextField("Owner First Name",
                              "owner_first_name"), // First name field
                          _buildTextField("Owner Last Name",
                              "owner_last_name"), // Last name field
                          _buildTextField("Owner Father Name",
                              "father_name"), // Last name field
                          _buildTextField(
                              "Owner Country Code", "owner_country_code",
                              initialValue: "+91"),
                          _buildTextField("Owner Phone", "owner_phone"),
                          _buildTextField("Owner Address", "owner_address"),
                          _buildTextField("Owner Email", "user_email"),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          CheckboxListTile(
                            title: const Text("Do you want a subscription?"),
                            value: wantsSubscription,
                            onChanged: (value) {
                              setState(() {
                                wantsSubscription = value ?? false;
                              });
                            },
                            activeColor: Colors.blueAccent,
                          ),
                          if (wantsSubscription)
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Select Subscription",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              items: subscriptionOptions.map((sub) {
                                return DropdownMenuItem(
                                  value: sub,
                                  child: Text(sub),
                                );
                              }).toList(),
                              onChanged: (value) {
                                widget.formData["subscription_id"] = value!;
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentStep > 0)
                  OutlinedButton(
                    onPressed: _previousStep,
                    child: Text("Back",
                        style: TextStyle(color: Colors.blueAccent)),
                  ),
                ElevatedButton(
                  onPressed: _nextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text(_currentStep == 2 ? "Submit" : "Next",
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
