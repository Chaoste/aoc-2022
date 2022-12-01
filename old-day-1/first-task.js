const fs = require("fs");

try {
  const data = fs.readFileSync("./input.txt", "utf8");
  const lines = data.split("\n");
  let lastValue = undefined;
  let counts = 0;
  lines.forEach((line) => {
    const number = parseInt(line, 10);
    counts += number > (lastValue === undefined ? number : lastValue);
    lastValue = number;
  });
  console.log("Increments:", counts);
} catch (err) {
  console.error(err);
}
