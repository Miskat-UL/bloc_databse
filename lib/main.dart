import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_database/data_features/data/models/single_model.dart';
import 'package:flutter_database/data_features/presentation/bloc/table_bloc.dart';
import 'package:flutter_database/data_features/presentation/bloc/table_data_block.dart';
import 'package:flutter_database/data_features/presentation/bloc/table_event.dart';
import 'package:flutter_database/data_features/presentation/bloc/table_state.dart';
import 'package:flutter_database/database_helper.dart';

import 'data_features/data/models/table_name_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TableBloc _tableBloc = TableBloc();
  final TableDataBloc _tableDataBloc = TableDataBloc();
  @override
  void initState() {
    _tableBloc.add(GetTableName());
    // _tableBloc.add(GetAlldata('CATEGORY'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // List<Education> ab = db.getDb("EDUCATION_LEVEL");

    return Scaffold(
      appBar: AppBar(
        title: Text('Database'),
      ),
      body: Container(
          child: BlocProvider(
        create: (_) => _tableBloc,
        child: BlocBuilder<TableBloc, TableState>(
          builder: (context, state) {
            if (state is TableError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
            if (state is TableLoaded) {
              print('sad');
              return TableNamesWidget(
                bloc: _tableBloc,
                tableList: state.tableName,
              );
            }
            return Container(
              child: Text('dasa'),
            );
          },
        ),
      )),
    );
  }
}

class TableNamesWidget extends StatelessWidget {
  const TableNamesWidget({
    Key? key,
    this.tableList,
    this.bloc,
  }) : super(key: key);
  final List<TableName>? tableList;
  final TableBloc? bloc;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Center(
        child: DropDownT(
          bloc: bloc,
          tableList: tableList,
        ),
      ),
    );
  }
}

class DropDownT extends StatefulWidget {
  const DropDownT({
    Key? key,
    this.tableList,
    this.bloc,
  }) : super(key: key);
  final List<TableName>? tableList;
  final TableBloc? bloc;
  @override
  State<DropDownT> createState() => _DropDownTState();
}

class _DropDownTState extends State<DropDownT> {
  String dropDownValue = "CATEGORY";
  final TableBloc _tableBloc = TableBloc();
  @override
  void initState() {
    _tableBloc.add(GetAlldata(dropDownValue));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: dropDownValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(color: Colors.deepPurple),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              setState(() {
                dropDownValue = value!;
                _tableBloc.add(GetAlldata(dropDownValue));
              });
            },
            items: widget.tableList!
                .map((e) => DropdownMenuItem<String>(
                      child: Text(e.tableName.toString()),
                      value: e.tableName.toString(),
                    ))
                .toList(),
          ),
          BlocProvider(
            create: (_) => _tableBloc,
            child: BlocBuilder<TableBloc, TableState>(
              builder: (context, state) {
                if (state is TableDataLoaded) {
                  return Container(
                    height: 200,
                    child: ListView.builder(
                      itemCount: state.tableData.length,
                      itemBuilder: (context, index) {
                        return Text(state.tableData[index].title.toString());
                      },
                    ),
                  );
                }
                return Container(
                  child: Text('dfdf'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// class ShowDatab extends StatefulWidget {
//   const ShowDatab({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<ShowDatab> createState() => _ShowDatabState();
// }

// class _ShowDatabState extends State<ShowDatab> {
//   final TableDataBloc _tableDataBloc = TableDataBloc();
//   @override
//   void initState() {
//     _tableDataBloc.add(GetAlldata('CATEGORY'));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => _tableDataBloc,
//       child: BlocBuilder<TableDataBloc, TableState>(builder: (context, state) {
//         return state is TableDataLoaded
//             ? ListView.builder(
//                 itemCount: state.tableData.length,
//                 itemBuilder: (context, index) {
//                   return Center(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 10),
//                       decoration: BoxDecoration(
//                         border: Border.all(width: 1, color: Colors.grey),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               '${state.tableData[index].id}',
//                               style: const TextStyle(
//                                 fontSize: 18,
//                               ),
//                             ),
//                           ),
//                           Text(
//                             '${state.tableData[index].title}',
//                             style: const TextStyle(
//                               fontSize: 18,
//                             ),
//                           ),
//                           Text(
//                             '${state.tableData[index].extra}',
//                             style: const TextStyle(
//                               fontSize: 18,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               )
//             : state is TableLoading
//                 ? CircularProgressIndicator()
//                 : CircularProgressIndicator();
//       }),
//     );
//   }
// }
