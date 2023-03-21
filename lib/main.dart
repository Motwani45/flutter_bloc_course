import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
          BlocProvider(create: (_) => PersonsBloc(), child: const MyHomePage()),
    );
  }
}

@immutable
abstract class LoadAction {
  const LoadAction();
}

@immutable
class LoadPersonsAction implements LoadAction {
  final PersonUrl url;
  const LoadPersonsAction({required this.url}) : super();
}

enum PersonUrl {
  persons1,
  persons2,
}

extension UrlString on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.persons1:
        return "http://10.0.2.2:8000/api/persons1.json";
      case PersonUrl.persons2:
        return "http://10.0.2.2:8000/api/persons2.json";
    }
  }
}

@immutable
class Person {
  String name;
  int age;
  Person.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        age = json['age'] as int;
}

Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((resp) => resp.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetreivedFromCache;

  FetchResult({required this.persons, required this.isRetreivedFromCache});
  @override
  String toString() {
    return 'FetchResult (isRetrievedFromCache = $isRetreivedFromCache , persons = $persons)';
  }
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> cache = {};
  PersonsBloc() : super(null) //Initial State
  {
    on<LoadPersonsAction>(
      (event, emit) async {
        final url = event.url;
        if (cache.containsKey(url)) {
          final _cachedPersons = cache[url];
          final result =
              FetchResult(persons: _cachedPersons!, isRetreivedFromCache: true);
          emit(result);
        } else {
          final persons = await getPersons(url.urlString);
          cache[url] = persons;
          final result =
              FetchResult(persons: persons, isRetreivedFromCache: false);
          emit(result);
        }
      },
    );
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bloc course"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    context
                        .read<PersonsBloc>()
                        .add(const LoadPersonsAction(url: PersonUrl.persons1));
                  },
                  child: const Text("Load JSON 1")),
              TextButton(
                  onPressed: () {
                    context
                        .read<PersonsBloc>()
                        .add(const LoadPersonsAction(url: PersonUrl.persons2));
                  },
                  child: const Text("Load JSON 2")),
            ],
          ),
          BlocBuilder<PersonsBloc, FetchResult?>(
              buildWhen: ((previousResult, currentResult) {
            return previousResult?.persons != currentResult?.persons;
          }), builder: (context, fetchResult) {
            final persons = fetchResult?.persons;
            if (persons == null) {
              return const SizedBox();
            }
            return Expanded(
              child: ListView.builder(
                  itemCount: persons.length,
                  itemBuilder: (context, index) {
                    final person = persons[index]!;
                    return ListTile(
                      title: Text(person.name),
                    );
                  }),
            );
          })
        ],
      ),
    );
  }
}
