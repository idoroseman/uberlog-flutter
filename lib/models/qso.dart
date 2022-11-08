class QSO implements Comparable {
  Map data;

  QSO({this.data});

  @override
  int compareTo(other) {
    if (this.data['QSO_DATE'] == null ||
        this.data['TIME_ON'] == null ||
        other.data['QSO_DATE'] == null ||
        other.data['TIME_ON'] == null) {
      return null;
    }

    return (other.data['QSO_DATE'] + other.data['TIME_ON'])
        .compareTo(this.data['QSO_DATE'] + this.data['TIME_ON']);
  }
}
