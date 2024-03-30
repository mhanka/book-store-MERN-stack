import dotenv from "dotenv";
dotenv.config();
export const PORT = 5000;

export const MONGODBURL = process.env.MONGODB_URL;
