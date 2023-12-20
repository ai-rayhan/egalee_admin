import 'package:flutter/material.dart';

class JobDetailsScreen extends StatelessWidget {
  const JobDetailsScreen({super.key, required this.jobdata});
  final Map<String, dynamic> jobdata;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('বিস্তারিত')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                color: Colors.black12,
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 2, left: 12, top: 8, bottom: 8),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(jobdata['title'],
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(
                            height: 2,
                          ),
                          Text("subtitle",
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(
                            height: 2,
                          ),
                          Text("application deadline",
                              style: Theme.of(context).textTheme.titleSmall),
                          const SizedBox(
                            height: 2,
                          ),
                          Text("Apply link",
                              style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            "Source",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text("Place ",
                              style: Theme.of(context).textTheme.bodySmall),
                          const SizedBox(
                            height: 2,
                          ),
                        ]),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 300,
                width: double.infinity,
                color: Colors.green,
              ),
              ElevatedButton(
                  onPressed: () {},
                  child: const SizedBox(
                    width: double.infinity,
                    child: Center(child: Text("See On PDF")),
                  )),
              const Text("alert: give here discretions")
            ],
          ),
        ));
  }
}
