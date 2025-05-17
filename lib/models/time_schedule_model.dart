class ScheduleResponse {
  final List<ScheduleItem> scheduleList;

  ScheduleResponse({required this.scheduleList});

  factory ScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ScheduleResponse(
      scheduleList: List<ScheduleItem>.from(
        json['schedule_list'].map((item) => ScheduleItem.fromJson(item)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schedule_list': scheduleList.map((item) => item.toJson()).toList(),
    };
  }
}

class ScheduleItem {
  final int id;
  final String name;

  ScheduleItem({required this.id, required this.name});

  factory ScheduleItem.fromJson(Map<String, dynamic> json) {
    return ScheduleItem(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
