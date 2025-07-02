/**
 * CatalogService provides operations and projections for managing and displaying books.
 *
 * Entities:
 * - ListOfBooks: Read-only projection of Books for listing purposes, excluding the 'descr' field.
 * - Books: Read-only projection of my.Books for detailed views, including all fields and the author's name,
 *   but excluding audit fields ('createdBy', 'modifiedBy').
 *
 * Actions:
 * - submitOrder: Allows authenticated users to submit an order for a book, specifying the book ID and quantity.
 *   Returns the updated stock for the ordered book.
 *
 * Events:
 * - OrderedBook: Event emitted when a book is ordered, containing the book ID, quantity, and buyer information.
 */
using { sap.capire.bookshop as my } from '../db/schema';
service CatalogService {

  /** For displaying lists of Books */
  @readonly entity ListOfBooks as projection on Books
  excluding { descr };

  /** For display in details pages */
  @readonly entity Books as projection on my.Books { *,
    author.name as author
  } excluding { createdBy, modifiedBy };

  @requires: 'authenticated-user'
  action submitOrder (
    book    : Books:ID @mandatory,
    quantity: Integer  @mandatory
  ) returns { stock: Integer };

  event OrderedBook : { book: Books:ID; quantity: Integer; buyer: String };
}
