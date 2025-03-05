import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tareas/providers/tasks_provider.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSummarySection(context),
            _buildTaskChart(context),
            _buildTaskDetails(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummarySection(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Resumen General',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSummaryItem(
                    context,
                    'Pendientes',
                    context
                        .watch<TasksProvider>()
                        .tasks
                        .where((task) =>
                            task.status == 'Pendiente' &&
                            task.date.isAfter(DateTime.now()))
                        .length),
                _buildSummaryItem(
                    context,
                    'Completadas',
                    context
                        .watch<TasksProvider>()
                        .tasks
                        .where((task) => task.status == 'Completado')
                        .length),
                _buildSummaryItem(
                    context,
                    'Vencidas',
                    context
                        .watch<TasksProvider>()
                        .tasks
                        .where((task) =>
                            task.date.isBefore(DateTime.now()) &&
                            task.status != 'Completado')
                        .length),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem(BuildContext context, String title, int count) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          '$count',
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskChart(BuildContext context) {
    int pending = context
        .watch<TasksProvider>()
        .tasks
        .where((task) =>
            task.status == 'Pendiente' && task.date.isAfter(DateTime.now()))
        .length;
    int completed = context
        .watch<TasksProvider>()
        .tasks
        .where((task) => task.status == 'Completado')
        .length;
    int overdue = context
        .watch<TasksProvider>()
        .tasks
        .where((task) =>
            task.date.isBefore(DateTime.now()) && task.status != 'Completado')
        .length;

    List<PieChartSectionData> sections = [];

    if (pending > 0) {
      sections.add(
        PieChartSectionData(
          value: pending.toDouble(),
          title: 'Pendientes',
          color: Color.fromARGB(255, 31, 97, 151),
        ),
      );
    }

    if (completed > 0) {
      sections.add(
        PieChartSectionData(
          value: completed.toDouble(),
          title: 'Completadas',
          color: Color.fromARGB(255, 62, 155, 65),
        ),
      );
    }

    if (overdue > 0) {
      sections.add(
        PieChartSectionData(
          value: overdue.toDouble(),
          title: 'Vencidas',
          color: Color.fromARGB(255, 209, 66, 56),
        ),
      );
    }

    if (pending == 0 && completed == 0 && overdue == 0) {
      return Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Distribución de Tareas',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'No hay gráfico para mostrar',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Distribución de Tareas',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: sections,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskDetails(BuildContext context) {
    var tasks = context.watch<TasksProvider>().tasks;

    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lista de Tareas',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 12),
            tasks.isEmpty
                ? Center(
                    child: Text(
                      'No hay tareas',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var task = tasks.reversed.toList()[index];
                      return Card(
                        elevation: 1,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
