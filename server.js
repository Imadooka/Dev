const express = require("express");
const cors = require("cors");
const app = express();
const port = 5001;

app.use(cors());

app.get("/api", (req, res) => {
  res.json({ message: "Hello from Express API!" });
});

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
