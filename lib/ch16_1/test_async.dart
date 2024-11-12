void main() {
  onPress();
}

Future<int> sum() {
  return Future<int>(() {
    var sum = 0;
    Stopwatch stopwatch = Stopwatch();
    stopwatch.start();
    for (int i = 0; i < 50000000; i++) {
      sum += i;
    }
    stopwatch.stop();
    print("${stopwatch.elapsed}, result: $sum");
    return sum;
  });
}

void onPress() {
  print('onPress top.....');
  sum();
  print('onPress bottom....');
}
