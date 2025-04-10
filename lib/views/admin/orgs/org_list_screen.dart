import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants/app_constants.dart';
import '../../../constants/url_constants.dart';
import 'add_org.dart';
import 'org_details_screen.dart';
import 'package:dio/dio.dart';

class OrgListScreen extends StatefulWidget {
  const OrgListScreen({Key? key}) : super(key: key);

  @override
  _OrgListScreenState createState() => _OrgListScreenState();
}

class _OrgListScreenState extends State<OrgListScreen> {
  List<Map<String, dynamic>> organizations = [];
  List<Map<String, dynamic>> filteredOrganizations = [];
  TextEditingController searchController = TextEditingController();
  bool _loading = true;
  final Map<String, String> formData = {
    "org_name": "",
    "email": "",
    "country_code": "+91",
    "phone": "",
    "address": "",
    "org_id": "",
    "owner_first_name": "",
    "owner_last_name": "",
    "owner_country_code": "+91",
    "owner_phone": "",
    "owner_address": ""
  };

  final String baseUrl = APPConstants.BASE_URL;
  final String getAllOrgsEndpoint = URLConstants.getAllOrgs;

  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    setState(() {
      _loading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');

      final response = await _dio.get(
        '$baseUrl$getAllOrgsEndpoint',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken', // Send as Bearer token
          },
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = response.data;

        if (responseData['statusCode'] == 200 && responseData['message'] == "Success") {
          List<dynamic> data = responseData['data'];
          organizations = data.map<Map<String, dynamic>>((item) => {
            "org_id": item["organizationId"] ?? "",
            "name": item["organizationName"] ?? "N/A",
            "email": "contact@example.com",
            "country_code": item["countryCode"] ?? "",
            "phone": item["mobileNumber"] ?? "",
            "address": item["address"] ?? "N/A",
            "subscription_end_date": DateTime.now().add(Duration(days: 30)),
          }).toList();
          filteredOrganizations = List.from(organizations);
        } else {
          print("API Error: ${responseData['message']}");
        }
      } else {
        print("HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      // Handle DioError exceptions
      if (e is DioException) {
        print("DioError: ${e.message}");
        if (e.response != null) {
          print("Response data: ${e.response!.data}");
          print("Response headers: ${e.response!.headers}");
        } else {
          print("Request failed to send.");
        }
      } else {
        print("Error fetching data: $e");
      }
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  void _filterOrganizations(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredOrganizations = List.from(organizations);
      } else {
        filteredOrganizations = organizations
            .where((org) => org["name"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(0, 3))
                ],
              ),
              child: TextField(
                controller: searchController,
                onChanged: _filterOrganizations,
                decoration: InputDecoration(
                  hintText: "Search organizations...",
                  prefixIcon: Icon(Icons.search, color: Color(0xFF1E88E5)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: filteredOrganizations.length,
                itemBuilder: (context, index) {
                  final org = filteredOrganizations[index];
                  return Container(
                     margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 3))
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(16),
                      title: Text(
                        org["name"],
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5),
                          Text("📧 ${org["email"]}"),
                          Text("📍 ${org["address"]}"),
                          Text("📞 ${org["country_code"]} ${org["phone"]}"),
                          Text("📅 Subscription Ends: ${_formatDate(org["subscription_end_date"])}"),
                        ],
                      ),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1E88E5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrgDetailsScreen(orgId: org["org_id"]!),
                            ),
                          );
                        },
                        child: Text(
                          "View",
                          style: TextStyle(color: Color(0xFFF5F5F5)),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddOrgScreen(formData: formData,),
        ),
        backgroundColor: Color(0xFF1E88E5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
