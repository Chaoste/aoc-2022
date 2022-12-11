import java.io.FileNotFoundException;
import java.io.FileReader;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Scanner;
import java.util.function.Function;
import java.util.stream.Collectors;
import java.util.stream.Stream;

class Monkey {
  Integer activity = 0;
  ArrayList<BigInteger> items;
  Function<BigInteger, BigInteger> prioOp;
  Function<BigInteger, Integer> passOp;

  Monkey(List<BigInteger> items, Function<BigInteger, BigInteger> prioOp, Function<BigInteger, Integer> passOp) {
    this.items = new ArrayList<>(items);
    this.prioOp = prioOp;
    this.passOp = passOp;
  }

  void inspect(List<Monkey> monkeys) {
    while (this.items.size() > 0) {
      this.activity++;
      BigInteger item = this.items.remove(0);
      BigInteger newPrio = this.prioOp.apply(item).divide(BigInteger.valueOf(3));
      int newMonkey = this.passOp.apply(newPrio);
      // System.out.println("> " + item + " " + newPrio + " " + newMonkey);
      monkeys.get(newMonkey).addItem(newPrio);
    }
  }

  void addItem(BigInteger prio) {
    this.items.add(prio);
  }
}

public class ExerciseA {

  public static ArrayList<String> readInput() {
    ArrayList<String> sb = new ArrayList<String>();
    try (Scanner in = new Scanner(new FileReader("input.txt"))) {
      while (in.hasNextLine()) {
        String line = in.nextLine();
        sb.add(line);
      }
      in.close();
    } catch (FileNotFoundException e) {
      e.printStackTrace();
    }
    return sb;
  }

  // Src: https://stackoverflow.com/a/16385929/4816930
  public static int[] twoLargest(int values[]) {
    int largestA = Integer.MIN_VALUE, largestB = Integer.MIN_VALUE;

    for (int value : values) {
      if (value > largestA) {
        largestB = largestA;
        largestA = value;
      } else if (value > largestB) {
        largestB = value;
      }
    }
    return new int[] { largestA, largestB };
  }

  public static void main(String[] args) {
    ArrayList<String> lines = ExerciseA.readInput();
    ArrayList<Monkey> monkeys = new ArrayList<Monkey>();

    for (int i = 0; i < lines.size() - 1; i += 7) {
      String line = lines.get(i);
      Stream<String> initialItemsAsStr = Arrays.asList(lines.get(i + 1).substring(18).split(", ")).stream();
      List<BigInteger> initialItems = initialItemsAsStr.map(Integer::parseInt).map(BigInteger::valueOf)
          .collect(Collectors.toList());
      Boolean isAddOp = lines.get(i + 2).substring(23, 24).equals("+");
      Boolean isOtherOld = lines.get(i + 2).substring(25).equals("old");
      Function<BigInteger, BigInteger> prioOp = isAddOp ? ((x) -> x.add(x)) : ((x) -> x.multiply(x));
      if (!isOtherOld) {
        BigInteger otherOpNumber = BigInteger.valueOf(Integer.parseInt(lines.get(i + 2).substring(25)));
        prioOp = isAddOp ? ((x) -> x.add(otherOpNumber)) : ((x) -> x.multiply(otherOpNumber));
      }
      BigInteger divisibleBy = BigInteger.valueOf(Integer.parseInt(lines.get(i + 3).substring(21)));
      Integer targetA = Integer.parseInt(lines.get(i + 4).substring(29));
      Integer targetB = Integer.parseInt(lines.get(i + 5).substring(30));
      Function<BigInteger, Integer> passOp = (x) -> (x.mod(divisibleBy).equals(BigInteger.valueOf(0))) ? targetA
          : targetB;

      if (line.startsWith("Monkey")) {
        Monkey newMonkey = new Monkey(initialItems, prioOp, passOp);
        monkeys.add(newMonkey);
      }
    }
    int n_monkeys = monkeys.size();
    int n_rounds = 20;
    for (int i = 0; i < n_rounds; i++) {
      for (int j = 0; j < n_monkeys; j++) {
        // System.out.println("Monkey " + j);
        monkeys.get(j).inspect(monkeys);
      }
    }
    ArrayList<Integer> activities = new ArrayList<Integer>();
    for (int j = 0; j < n_monkeys; j++) {
      Monkey monkey = monkeys.get(j);
      activities.add(monkey.activity);
      System.out.println("#" + (j + 1) + " " + monkey.items + " - " + monkey.activity);
    }
    int[] largest = ExerciseA.twoLargest(activities.stream().mapToInt(Integer::intValue).toArray());
    System.out.println("Monkey Business: " + largest[0] * largest[1]);

  }
}