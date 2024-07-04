import 'dart:io';

class Book {
  String title;
  String author;
  String isbn;
  int copies;

  Book(this.title, this.author, this.isbn, this.copies);

  bool canBorrow() {
    return copies > 0;
  }

  void borrowBook() {
    if (canBorrow()) {
      copies--;
      print('$title borrowed successfully.');
    } else {
      print('$title is not available.');
    }
  }

  void returnBook() {
    copies++;
    print('$title returned successfully.');
  }
}

class Member {
  String name;
  String memberId;
  List<Book> borrowedBooks = [];

  Member(this.name, this.memberId);

  void borrowBook(Book book) {
    if (book.canBorrow()) {
      book.borrowBook();
      borrowedBooks.add(book);
      print('$name borrowed ${book.title}.');
    } else {
      print('${book.title} is not available for borrowing.');
    }
  }

  void returnBook(Book book) {
    book.returnBook();
    borrowedBooks.remove(book);
    print('$name returned ${book.title}.');
  }
}

class Library {
  List<Book> books = [];
  List<Member> members = [];

  void addBook(Book book) {
    bool bookExists = books.any((b) => b.isbn == book.isbn);
    if (bookExists) {
      print('Book with ISBN ${book.isbn} already exists in the library.');
    } else {
      books.add(book);
      print('${book.title} added to the library.');
    }
  }

  void removeBook(Book book) {
    books.remove(book);
    print('${book.title} removed from the library.');
  }

  void registerMember(Member member) {
    bool memberExists = members.any((m) => m.memberId == member.memberId);
    if (memberExists) {
      print('Member with ID ${member.memberId} already exists.');
    } else {
      members.add(member);
      print('${member.name} registered successfully.');
    }
  }

  void borrowBook(String memberId, String isbn) {
    Member? member = members.firstWhere(
      (m) => m.memberId == memberId, orElse: () => Member('Unknown', '0')
      );
    Book? book = books.firstWhere((b) => b.isbn == isbn, 
    orElse: () => Book('Unknown', 'Unknown', '0', 0));

    if (member.memberId != '0' && book.isbn != '0') {
      member.borrowBook(book);
    } else {
      print('Member or Book not found.');
    }
  }

  void returnBook(String memberId, String isbn) {
    Member? member = members.firstWhere((m) => m.memberId == memberId, 
    orElse: () => Member('Unknown', '0'));
    Book? book = books.firstWhere((b) => b.isbn == isbn, 
    orElse: () => Book('Unknown', 'Unknown', '0', 0));

    if (member.memberId != '0' && book.isbn != '0') {
      member.returnBook(book);
    } else {
      print('Member or Book not found.');
    }
  }

  void displayBooks() {
    if (books.isNotEmpty) {
      for (var book in books) {
        print('Title: ${book.title}, Author: ${book.author}, ISBN: ${book.isbn}, Copies: ${book.copies}');
      }
    } else {
      print('No books available.');
    }
  }

  void displayMembers() {
    if (members.isNotEmpty) {
      for (var member in members) {
        print('Name: ${member.name}, Member ID: ${member.memberId}');
      }
    } else {
      print('No members registered.');
    }
  }

  void displayBorrowedBooks() {
    bool borrowedBooksExist = false;
    for (var member in members) {
      if (member.borrowedBooks.isNotEmpty) {
        print('Member: ${member.name}');
        for (var book in member.borrowedBooks) {
          print('Borrowed Book: ${book.title}');
        }
        borrowedBooksExist = true;
      }
    }
    if (!borrowedBooksExist) {
      print('No borrowed books at the moment.');
    }
  }
}

void main() {

  Library library = Library();

  Book book1 = Book('The Catcher in the Rye', 'J.D. Salinger', '9780316769488', 5);
  Book book2 = Book('To Kill a Mockingbird', 'Harper Lee', '9780061120084', 3);
  Book book3 = Book('1984', 'George Orwell', '9780451524935', 4);
  Book book4 = Book('The Great Gatsby', 'F. Scott Fitzgerald', '9780743273565', 2);
  Book book5 = Book('Moby Dick', 'Herman Melville', '9781503280786', 1);

  Member member1 = Member('suzuki', '001');
  Member member2 = Member('honda', '002');
  Member member3 = Member('wave', '003');

  library.registerMember(member1);
  library.registerMember(member2);
  library.registerMember(member3);

  library.addBook(book1);
  library.addBook(book2);
  library.addBook(book3);
  library.addBook(book4);
  library.addBook(book5);

  while (true) {
    print('''

______________[ Library ]______________
1. Add Book
2. Register Member
3. Borrow Book
4. Return Book
5. Display Books
6. Display Members
7. Display Borrowed Books
Q. Exit 
''');

    stdout.write('Please enter your choice (1-7 or Q): ');

    String? choice = stdin.readLineSync();

    if (choice == 'Q' || choice == 'q') {
      break;
    }

    switch (choice) {
      case '1':
        print('Add new book');
        stdout.write('Title: ');
        String title = stdin.readLineSync()!;
        stdout.write('Author: ');
        String author = stdin.readLineSync()!;
        stdout.write('ISBN: ');
        String isbn = stdin.readLineSync()!;
        stdout.write('Copies: ');
        int copies = int.parse(stdin.readLineSync()!);
        Book book = Book(title, author, isbn, copies);
        library.addBook(book);
        break;

      case '2':
        print('Register new member');
        stdout.write('Name: ');
        String name = stdin.readLineSync()!;
        stdout.write('Member ID: ');
        String memberId = stdin.readLineSync()!;
        Member member = Member(name, memberId);
        library.registerMember(member);
        break;

      case '3':
        print('Borrow book');
        stdout.write('Member ID: ');
        String borrowMemberId = stdin.readLineSync()!;
        stdout.write('ISBN: ');
        String borrowIsbn = stdin.readLineSync()!;
        library.borrowBook(borrowMemberId, borrowIsbn);
        break;

      case '4':
        print('Return book');
        stdout.write('Member ID: ');
        String returnMemberId = stdin.readLineSync()!;
        stdout.write('ISBN: ');
        String returnIsbn = stdin.readLineSync()!;
        library.returnBook(returnMemberId, returnIsbn);
        break;

      case '5':
        print('\n[Displaying all books]');
        library.displayBooks();
        break;

      case '6':
        print('\n[Displaying all members]');
        library.displayMembers();
        break;

      case '7':
        print('\n[Displaying all borrowed books]');
        library.displayBorrowedBooks();
        break;

      default:
        print('Invalid choice. Please try again.');
    }
  }
}
