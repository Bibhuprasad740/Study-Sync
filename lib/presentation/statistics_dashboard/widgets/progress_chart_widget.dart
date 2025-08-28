import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressChartWidget extends StatefulWidget {
  final List<FlSpot> chartData;
  final String selectedPeriod;

  const ProgressChartWidget({
    super.key,
    required this.chartData,
    required this.selectedPeriod,
  });

  @override
  State<ProgressChartWidget> createState() => _ProgressChartWidgetState();
}

class _ProgressChartWidgetState extends State<ProgressChartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Chart header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getChartTitle(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  Text(
                    _getChartSubtitle(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ],
              ),
              _buildAverageIndicator(),
            ],
          ),

          SizedBox(height: 20),

          // Chart
          Expanded(
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    setState(() {
                      if (touchResponse != null &&
                          touchResponse.lineBarSpots != null) {
                        touchedIndex =
                            touchResponse.lineBarSpots!.first.spotIndex;
                      } else {
                        touchedIndex = -1;
                      }
                    });
                  },
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor:
                        Theme.of(context).colorScheme.inverseSurface,
                    tooltipRoundedRadius: 8,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '${_getTooltipLabel(barSpot.x.toInt())}\n${barSpot.y.toStringAsFixed(1)}${_getUnit()}',
                          TextStyle(
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
                            fontWeight: FontWeight.w500,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: false,
                  horizontalInterval: _getHorizontalInterval(),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _getBottomInterval(),
                      getTitlesWidget: (value, meta) =>
                          _bottomTitleWidgets(value, meta),
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: _getHorizontalInterval(),
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) =>
                          _leftTitleWidgets(value, meta),
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.1),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.chartData,
                    isCurved: true,
                    curveSmoothness: 0.3,
                    color: Theme.of(context).colorScheme.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        final isSelected = index == touchedIndex;
                        return FlDotCirclePainter(
                          radius: isSelected ? 6 : 4,
                          color: isSelected
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.primary,
                          strokeWidth: isSelected ? 2 : 0,
                          strokeColor: Theme.of(context).colorScheme.surface,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.2),
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.05),
                        ],
                      ),
                    ),
                  ),
                ],
                minX: 0,
                maxX: _getMaxX(),
                minY: _getMinY(),
                maxY: _getMaxY(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAverageIndicator() {
    final average = widget.chartData.map((e) => e.y).reduce((a, b) => a + b) /
        widget.chartData.length;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.trending_up,
            size: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(width: 4),
          Text(
            'Avg: ${average.toStringAsFixed(1)}${_getUnit()}',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  String _getChartTitle() {
    switch (widget.selectedPeriod) {
      case 'Week':
        return 'Daily Performance';
      case 'Month':
        return 'Weekly Completion Rate';
      case 'Year':
        return 'Monthly Progress';
      default:
        return 'Progress';
    }
  }

  String _getChartSubtitle() {
    switch (widget.selectedPeriod) {
      case 'Week':
        return 'Average score per day';
      case 'Month':
        return 'Percentage of completed topics';
      case 'Year':
        return 'Overall completion percentage';
      default:
        return '';
    }
  }

  String _getUnit() {
    switch (widget.selectedPeriod) {
      case 'Week':
        return '/10';
      case 'Month':
      case 'Year':
        return '%';
      default:
        return '';
    }
  }

  double _getMaxX() {
    switch (widget.selectedPeriod) {
      case 'Week':
        return 6;
      case 'Month':
        return 30;
      case 'Year':
        return 12;
      default:
        return widget.chartData.length.toDouble() - 1;
    }
  }

  double _getMinY() {
    switch (widget.selectedPeriod) {
      case 'Week':
        return 0;
      case 'Month':
      case 'Year':
        return 50;
      default:
        return 0;
    }
  }

  double _getMaxY() {
    switch (widget.selectedPeriod) {
      case 'Week':
        return 10;
      case 'Month':
      case 'Year':
        return 100;
      default:
        return 100;
    }
  }

  double _getHorizontalInterval() {
    switch (widget.selectedPeriod) {
      case 'Week':
        return 2;
      case 'Month':
      case 'Year':
        return 10;
      default:
        return 10;
    }
  }

  double _getBottomInterval() {
    switch (widget.selectedPeriod) {
      case 'Week':
        return 1;
      case 'Month':
        return 5;
      case 'Year':
        return 2;
      default:
        return 1;
    }
  }

  String _getTooltipLabel(int index) {
    switch (widget.selectedPeriod) {
      case 'Week':
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return index < days.length ? days[index] : 'Day ${index + 1}';
      case 'Month':
        return 'Day ${index + 1}';
      case 'Year':
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec'
        ];
        return index < months.length ? months[index] : 'Month ${index + 1}';
      default:
        return 'Point ${index + 1}';
    }
  }

  Widget _bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.w400);

    String text = '';
    switch (widget.selectedPeriod) {
      case 'Week':
        const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
        if (value.toInt() < days.length) {
          text = days[value.toInt()];
        }
        break;
      case 'Month':
        if (value.toInt() % 5 == 0) {
          text = '${value.toInt() + 1}';
        }
        break;
      case 'Year':
        const months = [
          'J',
          'F',
          'M',
          'A',
          'M',
          'J',
          'J',
          'A',
          'S',
          'O',
          'N',
          'D'
        ];
        if (value.toInt() < months.length) {
          text = months[value.toInt()];
        }
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: style.copyWith(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }

  Widget _leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10, fontWeight: FontWeight.w400);

    String text = '';
    switch (widget.selectedPeriod) {
      case 'Week':
        text = value.toInt().toString();
        break;
      case 'Month':
      case 'Year':
        text = '${value.toInt()}%';
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        text,
        style: style.copyWith(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}
