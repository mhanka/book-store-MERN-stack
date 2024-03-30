import express from "express";
import { Book } from "../models/bookModel.js";
const Router = express.Router();

//Route to get all books
Router.get("/", async (request, response) => {
  try {
    const books = await Book.find({});
    return response.status(200).json({
      count: books.length,
      data: books,
    });
  } catch (error) {
    console.log(error.message);
    return response.status(500).send({ message: "error message" });
  }
});

//Route to get book by id
Router.get("/:id", async (request, response) => {
  try {
    const book = await Book.findById(request.params.id);
    return response.status(200).json({
      data: book,
    });
  } catch (error) {
    console.log(error.message);
    return response.status(500).send({ message: "error message" });
  }
});

//Route to update a book

Router.put("/:id", async (request, response) => {
  try {
    const book = await Book.findById(request.params.id);
    if (book) {
      book.title = request.body.title || book.title;
      book.author = request.body.author || book.author;
      book.publishYear = request.body.publishYear || book.publishYear;
      const updatedBook = await book.save();
      return response.status(200).send(updatedBook);
    }
    return response.status(404).send({ message: "Book not found" });
  } catch (error) {
    console.log(error.message);
    return response.status(500).send({ message: error.message });
  }
});

//Route to delete a book

Router.delete("/:id", async (request, response) => {
  try {
    const book = await Book.findById(request.params.id);
    if (book) {
      await book.deleteOne();
      return response.status(200).send({ message: "Book deleted" });
    }
    return response.status(404).send({ message: "Book not found" });
  } catch (error) {
    console.log(error.message);
    return response.status(500).send({ message: error.message });
  }
});

//Route to post all books
Router.post("/", async (request, response) => {
  try {
    if (
      !request.body.title ||
      !request.body.author ||
      !request.body.publishYear
    ) {
      return response
        .status(400)
        .send({ message: "All details must be filled" });
    }
    const newBook = {
      title: request.body.title,
      author: request.body.author,
      publishYear: request.body.publishYear,
    };
    const book = await Book.create(newBook);
    return response.status(201).send(book);
  } catch (error) {
    console.log(error.message);
    return response.status(500).send({ message: "error message" });
  }
});

export default Router;
