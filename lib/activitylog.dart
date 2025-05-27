import 'package:cropcure_admin/controller.dart';
import 'package:cropcure_admin/login.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class ActivityLogScreen extends StatefulWidget {
  const ActivityLogScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ActivityLogScreenState createState() => _ActivityLogScreenState();
}

class _ActivityLogScreenState extends State<ActivityLogScreen> {
  String searchQuery = "";
  String filterType = "All"; // Filter types: All, Online, Offline
  final Controller controller = Get.put(Controller());

  // Function to show logout confirmation dialog
  Future<void> _showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 63, 150, 69),
          elevation: 10,
          shadowColor: Colors.black,
          title: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.red, Color.fromARGB(255, 77, 6, 1)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 73, 223, 93),
                        Color.fromARGB(255, 38, 117, 50),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 1, color: Colors.white),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                        _logout(); // Implement logout action here
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  // Logout action
  void _logout() {
    Get.offAll(() => MyLogin());
    Get.snackbar('Success', 'Logged Out Success!');
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await controller.fetchPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        toolbarHeight: 80,
        title: const Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Analytics',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50, top: 30),
            child: IconButton(
              icon: const Icon(Icons.exit_to_app, color: Colors.black),
              onPressed: _showLogoutDialog,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 50),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height - 100,
            ),
            child: Column(children: [diseaseScanAndHistoryCard()]),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required int count,
    required String imagePath,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.transparent,
            border: Border.all(width: 2, color: color),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100, width: 100, child: Image.asset(imagePath)),
              const SizedBox(width: 20),
              Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "$count",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget diseaseScanAndHistoryCard() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate responsive dimensions
        final screenWidth = constraints.maxWidth;
        final isSmallScreen = screenWidth < 800;
        final isMediumScreen = screenWidth >= 800 && screenWidth < 1200;

        return Padding(
          padding: EdgeInsets.all(isSmallScreen ? 8.0 : 16.0),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12.0 : 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.analytics,
                        color: Colors.green,
                        size: isSmallScreen ? 24 : 28,
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 10),
                      Text(
                        "Disease Scans & History",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isSmallScreen ? 18 : 20,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 18),
                  // Chart
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    }

                    if (controller.history.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: isSmallScreen ? 36 : 48,
                              color: Colors.grey.shade400,
                            ),
                            SizedBox(height: isSmallScreen ? 12 : 16),
                            Text(
                              'No scan history yet',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 14 : 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final scansMap = controller.diseaseScansPerDay;
                    final days = scansMap.keys.toList()..sort();
                    final diseaseScans = days.map((d) => scansMap[d]!).toList();

                    return SizedBox(
                      height: isSmallScreen ? 150 : 200,
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            getDrawingHorizontalLine:
                                (value) => FlLine(
                                  color: Colors.green.shade50,
                                  strokeWidth: 1,
                                ),
                            getDrawingVerticalLine:
                                (value) => FlLine(
                                  color: Colors.green.shade50,
                                  strokeWidth: 1,
                                ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: isSmallScreen ? 24 : 32,
                                getTitlesWidget:
                                    (value, meta) => Text(
                                      value.toInt().toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: isSmallScreen ? 10 : 12,
                                      ),
                                    ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  int idx = value.toInt();
                                  if (idx >= 0 && idx < days.length) {
                                    return Text(
                                      days[idx],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                        fontSize: isSmallScreen ? 10 : 12,
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                                interval: isSmallScreen ? 2 : 1,
                              ),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: Border.all(color: Colors.green, width: 1),
                          ),
                          minX: 0,
                          maxX: (days.length - 1).toDouble(),
                          minY: 0,
                          maxY:
                              (diseaseScans.isEmpty
                                      ? 1
                                      : diseaseScans.reduce(
                                            (a, b) => a > b ? a : b,
                                          ) +
                                          2)
                                  .toDouble(),
                          lineBarsData: [
                            LineChartBarData(
                              spots: List.generate(
                                diseaseScans.length,
                                (i) => FlSpot(
                                  i.toDouble(),
                                  diseaseScans[i].toDouble(),
                                ),
                              ),
                              isCurved: true,
                              color: Colors.green,
                              barWidth: isSmallScreen ? 3 : 4,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter:
                                    (spot, percent, bar, index) =>
                                        FlDotCirclePainter(
                                          radius: isSmallScreen ? 4 : 6,
                                          color: Colors.white,
                                          strokeWidth: isSmallScreen ? 2 : 3,
                                          strokeColor: Colors.green,
                                        ),
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.withOpacity(0.3),
                                    Colors.green.withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                          lineTouchData: LineTouchData(
                            enabled: true,
                            touchTooltipData: LineTouchTooltipData(
                              getTooltipItems: (touchedSpots) {
                                return touchedSpots.map((spot) {
                                  return LineTooltipItem(
                                    '${spot.y.toInt()}',
                                    TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: isSmallScreen ? 12 : 14,
                                    ),
                                  );
                                }).toList();
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: isSmallScreen ? 16 : 24),
                  // Table
                  Text(
                    "Scan History",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: isSmallScreen ? 15 : 17,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 8 : 10),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.green),
                      );
                    }

                    if (controller.history.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                          child: Text(
                            'No scan history available',
                            style: TextStyle(
                              fontSize: isSmallScreen ? 14 : 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    }

                    return ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth:
                                isSmallScreen
                                    ? screenWidth - 40
                                    : screenWidth - 100,
                          ),
                          child: DataTable(
                            headingRowColor:
                                WidgetStateProperty.resolveWith<Color?>(
                                  (states) => Colors.green.shade100,
                                ),
                            dataRowColor:
                                WidgetStateProperty.resolveWith<Color?>((
                                  states,
                                ) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors.green.shade50;
                                  }
                                  return Colors.white;
                                }),
                            columnSpacing: isSmallScreen ? 16 : 32,
                            horizontalMargin: isSmallScreen ? 16 : 24,
                            dividerThickness: 0.8,
                            columns: [
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 6.0 : 8.0,
                                  ),
                                  child: Text(
                                    'Timestamp',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 6.0 : 8.0,
                                  ),
                                  child: Text(
                                    'Plant Name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 6.0 : 8.0,
                                  ),
                                  child: Text(
                                    'Disease',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: isSmallScreen ? 6.0 : 8.0,
                                  ),
                                  child: Text(
                                    'Treatment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                      fontSize: isSmallScreen ? 14 : 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            rows:
                                controller.history.asMap().entries.map((entry) {
                                  final idx = entry.key;
                                  final row = entry.value;
                                  return DataRow(
                                    color: WidgetStateProperty.resolveWith<
                                      Color?
                                    >((states) {
                                      if (idx % 2 == 0) {
                                        return Colors.green.withOpacity(0.04);
                                      }
                                      return Colors.white;
                                    }),
                                    cells: [
                                      DataCell(
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 6.0 : 8.0,
                                            horizontal:
                                                isSmallScreen ? 2.0 : 4.0,
                                          ),
                                          child: Text(
                                            row['timestamp'] is Timestamp
                                                ? DateFormat(
                                                  'MMM dd, yyyy HH:mm',
                                                ).format(
                                                  (row['timestamp']
                                                          as Timestamp)
                                                      .toDate(),
                                                )
                                                : row['timestamp']
                                                        ?.toString() ??
                                                    'N/A',
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 13 : 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 6.0 : 8.0,
                                            horizontal:
                                                isSmallScreen ? 2.0 : 4.0,
                                          ),
                                          child: Text(
                                            row['name']?.toString() ?? 'N/A',
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 13 : 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 6.0 : 8.0,
                                            horizontal:
                                                isSmallScreen ? 2.0 : 4.0,
                                          ),
                                          child: Text(
                                            row['disease']?.toString() ?? 'N/A',
                                            style: TextStyle(
                                              fontSize: isSmallScreen ? 13 : 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataCell(
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: isSmallScreen ? 6.0 : 8.0,
                                            horizontal:
                                                isSmallScreen ? 2.0 : 4.0,
                                          ),
                                          child:
                                              row['disease']
                                                          ?.toString()
                                                          .trim()
                                                          .toLowerCase() ==
                                                      'no disease detected'
                                                  ? Text(
                                                    'No treatment needed',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize:
                                                          isSmallScreen
                                                              ? 12
                                                              : 14,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  )
                                                  : TextButton(
                                                    onPressed:
                                                        () =>
                                                            _showPlantDetailsDialog(
                                                              context,
                                                              row,
                                                            ),
                                                    style: TextButton.styleFrom(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal:
                                                                isSmallScreen
                                                                    ? 8
                                                                    : 12,
                                                            vertical:
                                                                isSmallScreen
                                                                    ? 6
                                                                    : 8,
                                                          ),
                                                      backgroundColor: Colors
                                                          .green
                                                          .withOpacity(0.1),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              8,
                                                            ),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      'View Treatment',
                                                      style: TextStyle(
                                                        color: Colors.green,
                                                        fontSize:
                                                            isSmallScreen
                                                                ? 12
                                                                : 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPlantDetailsDialog(
    BuildContext context,
    Map<String, dynamic> plant,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.eco,
                            color: Colors.green,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Plant Details',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      icon: Icons.calendar_today,
                      title: 'Date & Time',
                      value:
                          plant['timestamp'] is Timestamp
                              ? DateFormat('MMM dd, yyyy HH:mm').format(
                                (plant['timestamp'] as Timestamp).toDate(),
                              )
                              : plant['timestamp']?.toString() ?? 'N/A',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.local_florist,
                      title: 'Plant Name',
                      value: plant['name']?.toString() ?? 'N/A',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.bug_report,
                      title: 'Disease',
                      value: plant['disease']?.toString() ?? 'N/A',
                      isDisease: true,
                    ),
                    if (plant['disease'] != null &&
                        plant['disease'].toString().trim().toLowerCase() !=
                            'no disease detected') ...[
                      const SizedBox(height: 16),
                      _buildDetailRow(
                        icon: Icons.medical_services,
                        title: 'Treatment',
                        value:
                            plant['treatment']?.toString() ??
                            'No treatment available',
                        isTreatment: true,
                      ),
                    ],
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            backgroundColor: Colors.green.withOpacity(0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
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
      },
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
    bool isDisease = false,
    bool isTreatment = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isDisease || isTreatment
                ? (isDisease
                    ? Colors.red.withOpacity(0.1)
                    : Colors.green.withOpacity(0.1))
                : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color:
                  isDisease || isTreatment
                      ? (isDisease
                          ? Colors.red.withOpacity(0.2)
                          : Colors.green.withOpacity(0.2))
                      : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color:
                  isDisease || isTreatment
                      ? (isDisease ? Colors.red : Colors.green)
                      : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        isDisease || isTreatment
                            ? (isDisease ? Colors.red : Colors.green)
                            : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
