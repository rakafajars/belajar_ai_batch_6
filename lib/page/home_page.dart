import 'package:belajar_ai_flutter_batch6/page/result_page.dart';
import 'package:belajar_ai_flutter_batch6/service/recommendation_service.dart';
import 'package:flutter/material.dart';

const List<String> carRegions = [
  "Asia",
  "Europe",
  "US",
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController _budgetController = TextEditingController();

  String carRegionValue = carRegions.first;
  bool isLoading = false;

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _getRecommendation() async {
    setState(() {
      isLoading = true;
    });
    try {
      final result = await RecommendationService().getRecommendation(
        carRegion: carRegionValue,
        budget: _budgetController.text,
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              gptData: result,
            ),
          ),
        );
      }
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Terjadi Kesalahan $e'),
      );

      if (mounted) {
        // Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar AI'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                heightFactor: 4,
                child: Text(
                  'Recomendation AI',
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(
                  left: 16,
                ),
                child: Text('Choose car regions'),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                ),
                child: DropdownButton<String>(
                  value: carRegionValue,
                  onChanged: (value) {
                    setState(() {
                      carRegionValue = value ?? "";
                    });
                  },
                  items: carRegions
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.only(
                  left: 16,
                ),
                child: Text('Input your budget in IDR'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _budgetController,
                  decoration: const InputDecoration(hintText: 'Input Budget'),
                  validator: (value) {
                    bool isInvalid = value == null ||
                        value.isEmpty ||
                        int.tryParse(value) == null;

                    if (isInvalid) {
                      return 'Please Enter Valid Number';
                    }

                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: isLoading && key.currentState!.validate() != false
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: _getRecommendation,
                        child: const Text(
                          'Get Recommendation',
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
