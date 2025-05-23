--to create the database with name LibraryManagementSystem
CREATE DATABASE LibraryManagementSystem;
--to use the database
USE LibraryManagementSystem;
----------------------------------------------------DDL (CREATION OF THE TABLE)-------------------------------------------------------------------------
--to create Library table
CREATE TABLE Library (
    LibraryID int PRIMARY KEY identity(1,1) NOT NULL, 
    LibraryName varchar(255) NOT NULL,
	LibraryLocation varchar(255) NOT NULL,
	Established_Year int NOT NULL CHECK(Established_Year > 1990)
);
--to create Library_Contact_Number table
CREATE TABLE Library_Contact_Number (
	Contact_Number int NOT NULL CONSTRAINT CK_Only8Digits CHECK(LEN(RTRIM(Contact_Number)) = 8),
	LibraryID int, foreign key(LibraryID) references Library(LibraryID)  
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	 PRIMARY KEY(LibraryID, Contact_Number)
);

--NOTE:
--CHECK(LEN(RTRIM(Contact_Number)) = 8) --> to make sure that Contact_Number length is not > 8
--	ON DELETE CASCADE / ON UPDATE CASCADE --> if any change happen to PK all the FK link to it will be changed

--to create Member table
CREATE TABLE Member (
    MemberID int PRIMARY KEY identity(1,1) NOT NULL, 
    Full_Name varchar(255) NOT NULL,
    Email varchar(255) NOT NULL,
	Membership_Start_Date Date NOT NULL,
	LibraryID int, foreign key(LibraryID) references Library(LibraryID)  
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);
--to create Member_Phone_Number table
CREATE TABLE Member_Phone_Number (
	Phone_Number int NOT NULL CONSTRAINT CK_Only8Digits_Member CHECK(LEN(RTRIM(Phone_Number)) = 8),
	MemberID int, foreign key(MemberID) references Member(MemberID)  
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	PRIMARY KEY(MemberID, Phone_Number)
);

--to create Staff table
CREATE TABLE Staff (
    Staff_ID int PRIMARY KEY identity(1,1) NOT NULL, 
    Full_Name varchar(255) NOT NULL,
    Position varchar(255) NOT NULL,
	LibraryID int, foreign key(LibraryID) references Library(LibraryID)  
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	MemberID int, foreign key(MemberID) references Member(MemberID)  
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
);
--to create Staff_Contact_Number table
CREATE TABLE Staff_Contact_Number (
	Contact_Number int NOT NULL CONSTRAINT CK_Only8Digits_Staff CHECK(LEN(RTRIM(Contact_Number)) = 8),
	Staff_ID int, foreign key(Staff_ID) references Staff(Staff_ID)  
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	PRIMARY KEY(Staff_ID, Contact_Number)
);

--to create Book table
CREATE TABLE Book (
    BookID int PRIMARY KEY identity(1,1) NOT NULL, 
    ISBN varchar(255) NOT NULL UNIQUE,
    Title varchar(255) NOT NULL,
	Genre varchar(255) NOT NULL,
	Shelf_Location varchar(255) NOT NULL,
	Price int NOT NULL CONSTRAINT CK_GraterThanZero CHECK(Price > 0),
	Availability_Status varchar(255) NOT NULL DEFAULT 'TRUE',
	LibraryID int, foreign key(LibraryID) references Library(LibraryID)  
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	MemberID int, foreign key(MemberID) references Member(MemberID)  
	ON DELETE NO ACTION
    ON UPDATE NO ACTION
);

--to create Loan table
CREATE TABLE Loan (
    LoanID int PRIMARY KEY identity(1,1) NOT NULL, 
    Loan_Date Date NOT NULL,
	Due_Date Date NOT NULL,
	Return_Date Date NOT NULL
);
--to create Payment table
CREATE TABLE Payment (
    PaymentID int PRIMARY KEY identity(1,1) NOT NULL, 
    Method varchar(255) NOT NULL,
	Amount int NOT NULL CONSTRAINT CK_GraterThanZero_Amount CHECK(Amount > 0),
	Payment_Date Date NOT NULL,
	LoanID int, foreign key(LoanID) references Loan(LoanID)  
	ON DELETE CASCADE 
    ON UPDATE CASCADE
);

--to create Member_books table
CREATE TABLE Member_books (
    Status varchar(255) NOT NULL DEFAULT 'Issued',
	LoanID int, foreign key(LoanID) references Loan(LoanID)  
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	MemberID int, foreign key(MemberID) references Member(MemberID)  
	ON DELETE NO ACTION
    ON UPDATE NO ACTION,
	BookID int, foreign key(BookID) references Book(BookID)  
	ON DELETE NO ACTION
    ON UPDATE NO ACTION,
	PRIMARY KEY(LoanID, MemberID, BookID)
);

--to create Review table
CREATE TABLE Review (
    ReviewID int PRIMARY KEY identity(1,1) NOT NULL, 
    Rating int NOT NULL CONSTRAINT Ch_Rating_From_One_To_Five CHECK (Rating > 0 and Rating < 6),
	Comment varchar(255) NOT NULL DEFAULT 'No comments'
);

--to create Member_reviewed_books table
CREATE TABLE Member_reviewed_books (
    Review_Date Date NOT NULL,
	ReviewID int, foreign key(ReviewID) references Review(ReviewID)  
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	MemberID int, foreign key(MemberID) references Member(MemberID)  
	ON DELETE NO ACTION
    ON UPDATE NO ACTION,
	BookID int, foreign key(BookID) references Book(BookID)  
	ON DELETE NO ACTION
    ON UPDATE NO ACTION,
	PRIMARY KEY(ReviewID, MemberID, BookID)
);

------------------------------------------------------------------DML (INSERATION DATA TO THE TABLES)---------------------------------------------------
--to insert date to Library table
INSERT INTO Library (LibraryName, LibraryLocation, Established_Year)
VALUES
('Central City Library', 'Downtown, Central City', 1995),
('Riverside Public Library', 'Riverside Blvd, Eastside', 2001),
('Greenwood Community Library', 'Greenwood Ave, Westside', 1998),
('Northview Library', 'Northview Rd, Uptown', 2005),
('Lakeside Knowledge Center', 'Lakeside Park, Southside', 2010);

SELECT * FROM Library;

--to insert date to Library_Contact_Number table
INSERT INTO Library_Contact_Number (Contact_Number, LibraryID)
VALUES
(12345678, 1),
(23456789, 2),
(34567890, 3),
(45678901, 4),
(56789012, 5);

SELECT * FROM Library_Contact_Number;

--to insert date to Member table
INSERT INTO Member (Full_Name, Email, Membership_Start_Date, LibraryID)
VALUES
('Alice Johnson', 'alice.johnson@example.com', '2023-01-15', 1),
('Brian Smith', 'brian.smith@example.com', '2022-11-10', 2),
('Carla Martinez', 'carla.martinez@example.com', '2023-03-05', 3),
('David Lee', 'david.lee@example.com', '2021-07-20', 4),
('Emma Brown', 'emma.brown@example.com', '2024-02-28', 5);

INSERT INTO Member (Full_Name, Email, Membership_Start_Date, LibraryID)
VALUES
('Jessica Miller', 'jessica.miller@example.com', '2024-05-10', 3);

SELECT * FROM Member;

--to insert date to Member_Phone_Number table
INSERT INTO Member_Phone_Number (Phone_Number, MemberID)
VALUES
(81234567, 1),
(82345678, 2),
(83456789, 3),
(84567890, 4),
(85678901, 5);

SELECT * FROM Member_Phone_Number;

--to insert date to Staff table
INSERT INTO Staff (Full_Name, Position, LibraryID, MemberID)
VALUES
('Laura Green', 'Librarian', 1, 1),
('Thomas Gray', 'Assistant Librarian', 2, 2),
('Nina Patel', 'Archivist', 3, 3),
('George Kim', 'Library Technician', 4, 4),
('Sophia Turner', 'Customer Service Rep', 5, 5);

SELECT * FROM Staff;

--to insert date to Staff_Contact_Number table
INSERT INTO Staff_Contact_Number (Contact_Number, Staff_ID)
VALUES
(87654321, 1),
(86543210, 2),
(85432109, 3),
(84321098, 4),
(83210987, 5);

SELECT * FROM Staff_Contact_Number;

--to insert date to Book table
INSERT INTO Book (ISBN, Title, Genre, Shelf_Location, Price, Availability_Status, LibraryID, MemberID)
VALUES
('978-1234567890', 'The Silent River', 'Mystery', 'Shelf A1', 25, 'FALSE', 1, 1),
('978-2345678901', 'Journey Through Time', 'Science Fiction', 'Shelf B2', 30, 'TRUE', 2, 2),
('978-3456789012', 'Gardening Basics', 'Non-Fiction', 'Shelf C3', 20, 'FALSE', 3, 3),
('978-4567890123', 'The Art of Cooking', 'Cooking', 'Shelf D4', 28, 'TRUE', 4, 4),
('978-5678901234', 'Legends of the East', 'Fantasy', 'Shelf E5', 35, 'FALSE', 5, 5);

INSERT INTO Book (ISBN, Title, Genre, Shelf_Location, Price, Availability_Status, LibraryID, MemberID)
VALUES
('978-1111111111', 'Deep Space Odyssey', 'Science Fiction', 'Shelf A1', 45, 'TRUE', 1, 1),
('978-2222222222', 'History of Rome', 'History', 'Shelf B2', 30, 'FALSE', 2, 2),
('978-3333333333', 'Cooking 101', 'Cooking', 'Shelf C3', 25, 'TRUE', 3, 3),
('978-4444444444', 'Modern Art', 'Art', 'Shelf D4', 50, 'FALSE', 4, 4),
('978-5555555555', 'Wildlife Photography', 'Photography', 'Shelf E5', 40, 'TRUE', 5, 5);

SELECT * FROM Book;

--to insert date to Loan table
INSERT INTO Loan (Loan_Date, Due_Date, Return_Date)
VALUES
('2024-12-01', '2024-12-15', '2024-12-14'),
('2025-01-10', '2025-01-24', '2025-01-20'),
('2025-02-05', '2025-02-19', '2025-02-18'),
('2025-03-01', '2025-03-15', '2025-03-16'),
('2025-04-12', '2025-04-26', '2025-04-25');

INSERT INTO Loan (Loan_Date, Due_Date, Return_Date)
VALUES
('2025-01-01', '2025-01-15', '2025-01-14'),
('2025-02-10', '2025-02-24', '2025-02-22'),
('2025-03-05', '2025-03-19', '2025-03-18'),
('2025-04-12', '2025-04-26', '2025-04-28'),
('2025-05-01', '2025-05-15', '2025-05-14');

SELECT * FROM Loan;

--to insert date to Payment table
INSERT INTO Payment (Method, Amount, Payment_Date, LoanID)
VALUES
('Credit Card', 50, '2024-12-16', 1),
('Cash', 30, '2025-01-21', 2),
('Debit Card', 40, '2025-02-19', 3),
('Credit Card', 60, '2025-03-17', 4),
('Online Transfer', 25, '2025-04-26', 5);

SELECT * FROM Payment;

--to insert date to Member_books table
INSERT INTO Member_books (Status, LoanID, MemberID, BookID) VALUES
('Issued', 1, 1, 1),
('Returned', 2, 2, 2),
('Overdue', 3, 3, 3),
('Issued', 4, 4, 4),
('Returned', 5, 5, 5);

SELECT * FROM Member_books;

--to insert date to Review table
INSERT INTO Review (Rating, Comment) VALUES
(5, 'Excellent book! Highly recommend.'),
(4, 'Good read, but a bit slow in the middle.'),
(3, 'Average, nothing special.'),
(2, 'Did not enjoy it much.'),
(1, 'Poor writing and confusing plot.');

INSERT INTO Review (Rating, Comment) VALUES
(4, 'Great book, enjoyed the storyline!');

SELECT * FROM Review;

--to insert date to Member_reviewed_books table
INSERT INTO Member_reviewed_books (Review_Date, ReviewID, MemberID, BookID) VALUES
('2025-05-01', 1, 1, 1),
('2025-05-02', 2, 2, 2),
('2025-05-03', 3, 3, 3),
('2025-05-04', 4, 4, 4),
('2025-05-05', 5, 5, 5);

SELECT * FROM Member_reviewed_books;
