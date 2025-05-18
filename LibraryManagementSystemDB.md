# **Library Management System DB**

## Description of database: 

 **The Library Management System** is designed to manage books, members, staff, 
loans, and transactions efficiently. The system includes libraries where each library 
has a unique ID, name, location, contact number, and established year. Each library 
must manage books, where each book is identified by a unique ID, ISBN, title, genre, 
price, availability status, and shelf location. A book belongs to exactly one library, 
and a library may own many books. 
Members can register with personal information such as ID, full name, email, phone 
number, and membership start date. A member can borrow zero or more books. 
Each loan links one member with one book and includes loan date, due date, return 
date, and status. 
Each loan may have zero or more fine payments, where a payment is uniquely 
identified and includes payment date, amount, and method. Payment always 
corresponds to one specific loan. 
Staff work at a specific library, identified by staff ID, full name, position, and contact 
number. Each library must have at least one staff member, but each member of staff 
works at only one library. 
Members may also review books, where a review includes a rating, comments, and 
review date. Each review is linked to a specific book and a specific member. A 
member can provide multiple reviews, and a book may receive many reviews. 

## **Day 1: System Analysis & Database Design**
### Draw the ERD Diagram:
  
   1. Include entities, attributes, keys, relationships, cardinality, and participation. 
   2. Use clear notation and include weak entities and M: N relationships. 

**1. libraries:**
- Attributes:
  - ID (Primary Key)
  - Name
  - Location
  - Contact_Number (Multi-valued)
  - Established_Year
    
**2. Book:**
- Attributes:
   - ID (Primary Key)
   - ISBN
   - Title
   - Genre
   - Price
   - Availability_S_tatus
   - Shelf_L_ocation

**3. Member:**
- Attributes:
   - ID (Primary Key)
   - Full_Name
   - Email
   - Phone_Number
   - Membership_Start_Date

**4. Loan:**
- Attributes:
  - Loan_Date
  - Due_Date
  - Return_Date

**5. Payment:**
- Attributes:
  - ID (Primary Key)
  - Payment_Date
  - Amount
  - Method

**6. Staff:**
- Attributes:
  - Staff_ID (Primary Key)
  - Full_Name
  - Position
  - Contact_Number

**7. Review:**
- Attributes:
  - Rating
  - Comments

![ERD Diagram](./image/LibraryManagmenetSystemERD.png)

### Map the ERD to Relational Schema:
- Convert the ERD into relational tables with PKs and FKs defined. 

![Mapping Diagram](./image/LibraryManagmenetSystemMapping.png)

### Normalization Practice 
- Choose 2–3 tables to normalize. 
- Show step-by-step conversion to 1NF → 2NF → 3NF. 
- Justify each normalization step. 

**1. Book table:**
|BookID |ISBN |Title |Genre |Shelf_Location |Price |Availability_Status |LibraryID |MemberID |
|-------|-----|------|------|---------------|------|--------------------|----------|---------|

- First Normal Form (1NF) 
  This step will not be executed because there are no duplicates in the columns.

- Second Normal Form (2NF) and Third Normal Form (3NF) 

|BookID |ISBN |Title |Genre |Shelf_Location |Price |Availability_Status |
|-------|-----|------|------|---------------|------|--------------------|

|BookID |LibraryID |MemberID |
|-------|----------|---------|

In these two steps we need to make sure that all non-key attributes must depend on the whole primary key 
and non-key attributes should depend only on the key, not other non-key attributes

**2. Member:**
|MemberID |Email |Full_Name |Membership_Start_Date |LibraryID |
|---------|------|----------|----------------------|----------|

- First Normal Form (1NF) 
  This step will not be executed because there are no duplicates in the columns.

- Second Normal Form (2NF) and Third Normal Form (3NF) 

|MemberID |Email |Full_Name |Membership_Start_Date |
|---------|------|----------|----------------------|

|MemberID |LibraryID |
|---------|----------|

## **Day 2: Database Implementation & Realistic Data**

### 1. Use DDL commands to create the physical schema:

```sql
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
```