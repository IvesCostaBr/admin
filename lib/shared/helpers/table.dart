import 'package:flutter/material.dart';

class CustomDataTable extends StatelessWidget {
  final String title;
  final List<DataColumn> columns;
  final List<DataRow> rows;
  final VoidCallback onAdd;
  final VoidCallback onExport;
  final ValueChanged<String> onFilterChanged;
  final ValueChanged<int> onRowsPerPageChanged;
  final ValueChanged<String?> onFilterKeyChanged;
  final List<String> filterKeys;
  final String selectedFilterKey;

  const CustomDataTable({
    required this.title,
    required this.columns,
    required this.rows,
    required this.onAdd,
    required this.onExport,
    required this.onFilterChanged,
    required this.onRowsPerPageChanged,
    required this.onFilterKeyChanged,
    required this.filterKeys,
    required this.selectedFilterKey,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Column(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 18,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<int>(
                    value: 10,
                    items: [10, 20, 50, 100].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text('Mostrar $value'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        onRowsPerPageChanged(value);
                      }
                    },
                  ),
                  const SizedBox(width: 10),
                  DropdownButton<String>(
                    value: selectedFilterKey,
                    
                    items: filterKeys.map((String key) {
                      return DropdownMenuItem<String>(
                        value: key,
                        child: Text('Filtrar por $key'),
                      );
                    }).toList(),
                    onChanged: onFilterKeyChanged,
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 200,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Filtrar valor',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: onFilterChanged,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: onAdd,
                    tooltip: 'Adicionar Novo Registro',
                  ),
                  IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: onExport,
                    tooltip: 'Exportar Dados',
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(5))
                ),
                child: DataTable(
                  columns: columns,
                  rows: rows,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
