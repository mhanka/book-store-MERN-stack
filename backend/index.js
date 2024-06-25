import dotenv from "dotenv";
dotenv.config();
import express from "express";
import { PORT, MONGODBURL } from "./config.js";
import mongoose from "mongoose";
import booksRoute from "./routes/booksRoute.js";
import cors from "cors";
const app = express();

app.use(express.json());

//CORS middleware
app.use(cors());
// app.use(
//   cors({
//     origin: "http://localhost:5555",
//     methods: ["GET", "POST", "PUT", "DELETE"],
//     allowedHeaders: ["Content-Type"],
//   })
// );
app.use("/api", booksRoute);
mongoose
  .connect(process.env.MONGODBURL, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log("App connected to DB");
    app.listen(PORT, () => {
      console.log(`App is listening to ${PORT}`);
    });
  })
  .catch((err) => {
    console.log(err);
  });
