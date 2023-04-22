import cors from "cors";
import express from "express";
import { zauktionBidProof } from "./genProof.js";
const app = express();
const port = 8080;

app.use(express.json())
app.use(express.urlencoded({extended: true}))
app.use(cors())

app.post("/gen-proof", async (req, res) => {
  if (!req.body) {
   return res.sendStatus(400);
  }
  const proof = await zauktionBidProof(req.body);
  res.status(200).json(proof);
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
