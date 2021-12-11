const fs = require("fs");

try {
  const data = fs.readFileSync("./input.txt", "utf8");
  const lines = data.split("\n");
  const numbers = lines.map((row) => parseInt(row, 10));
  let lastValue = undefined;
  let counts = 0;

  numbers.forEach((number, i) => {
    if (i < 2) return;
    const windowSum = numbers[i - 2] + numbers[i - 1] + numbers[i];
    counts += windowSum > (lastValue === undefined ? windowSum : lastValue);
    lastValue = windowSum;
  });
  console.log("Increments:", counts);
} catch (err) {
  console.error(err);
}
