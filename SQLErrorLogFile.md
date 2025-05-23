#  **SQL Error Log File**

## 1. Case 1:
I am trying to create Staff table with the following SQL command:
```sql
CREATE TABLE Staff (
    Staff_ID int PRIMARY KEY identity(1,1) NOT NULL, 
    Full_Name varchar(255) NOT NULL,
    Position varchar(255) NOT NULL,
	LibraryID int, foreign key(LibraryID) references Library(LibraryID)  
	ON DELETE CASCADE 
    ON UPDATE CASCADE,
	MemberID int, foreign key(MemberID) references Member(MemberID)  
	ON DELETE CASCADE
    ON UPDATE CASCADE
);
```
This table has two foreign keys, one for LibraryID and one for MemberID. and we are asked to add ON DELETE CASCADE and ON UPDATE CASCADE for both foreign keys.
but it is not working and I am getting the following error:
```sql
Msg 1785, Level 16, State 0, Line 46
Introducing FOREIGN KEY constraint 'FK__Staff__MemberID__4F7CD00D' on table 'Staff' may cause cycles or multiple cascade paths. Specify ON DELETE NO ACTION or ON UPDATE NO ACTION, or modify other FOREIGN KEY constraints.
Msg 1750, Level 16, State 1, Line 46
Could not create constraint or index. See previous errors.
```
So I understand that if we have to FK in one table we can not add ON DELETE CASCADE and ON UPDATE CASCADE for both of them.
and as the error show I change the command to:
```sql
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
```
## 2. Case 2:
I forget to add constraint of Genre column in Book table and I am trying to add it with the following command:
```sql
--1. update all the row in Book table to follow the constraint of Genre column 
UPDATE Book
SET Genre = 
    CASE (BookID % 4)
        WHEN 0 THEN 'Fiction'
        WHEN 1 THEN 'Non-fiction'
        WHEN 2 THEN 'Reference'
        WHEN 3 THEN 'Children'
    END;

--2. add constraint of Genre column
ALTER TABLE Book 
ADD CONSTRAINT Ch_Value_Is CHECK (Genre IN ( 'Fiction', 'Non-fiction', 'Reference', 'Children' ));
```
## 3. Case 3:
I am trying to delete a member from the Member table how has existing loans, written book reviews with the following command:
```sql
DELETE FROM Member 
WHERE MemberID = 5;
```
but I am getting the following error:
```sql
Msg 547, Level 16, State 0, Line 332
The DELETE statement conflicted with the REFERENCE constraint "FK__Staff__MemberID__534D60F1". The conflict occurred in database "LibraryManagementSystem", table "dbo.Staff", column 'MemberID'.
The statement has been terminated.

Completion time: 2025-05-18T14:28:36.4870140+04:00
```
I understand that this is because the member has is in the Staff table also and I can not delete it. So, I have to delete the member from the Staff table and every table which link to it first and then delete it from the Member table.
```sql
DELETE FROM Staff 
WHERE MemberID = 5; 

DELETE FROM Member_books 
WHERE MemberID = 5; 

DELETE FROM Member_reviewed_books 
WHERE MemberID = 5; 

DELETE FROM Book
WHERE MemberID = 5;  

DELETE FROM Member 
WHERE MemberID = 5;
```
## 4. Case 4:
I am trying to insert a loan for a member who doesn�t exist, a book that doesn�t exist by this command:
```sql
INSERT INTO Member_books (Status, LoanID, MemberID, BookID) VALUES
('Issued', 1, 30, 30);
```
but I am getting the following error:
```sql
Msg 547, Level 16, State 0, Line 362
The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Member_bo__Membe__6A30C649". The conflict occurred in database "LibraryManagementSystem", table "dbo.Member", column 'MemberID'.
The statement has been terminated.

Completion time: 2025-05-18T14:52:30.7892802+04:00
```
I understand that this is because the member and book does not exist in the Member and Book table. So, I have to insert the member and book first and then insert the loan.

## 5. Case 5:
I am trying to updating a book�s genre to 'Sci-Fi' which does not inclued in genre value by this command:
```sql
UPDATE Book 
SET Genre = 'Sci-Fi'
WHERE BookID = 1;
```
but I am getting the following error:
```sql
Msg 547, Level 16, State 0, Line 367
The UPDATE statement conflicted with the CHECK constraint "Ch_Value_Is". The conflict occurred in database "LibraryManagementSystem", table "dbo.Book", column 'Genre'.
The statement has been terminated.

Completion time: 2025-05-18T15:01:12.1841277+04:00
```
I understand that this is because genre have a set of value which need to be follow

## 6. Case 6:
I am trying to inserting a payment with zero or negative amount, missing payment method  by this command:
```sql
INSERT INTO Payment (Method, Amount, Payment_Date, LoanID)
VALUES
( 0, '2025-04-26', 5);
```
but I am getting the following error:
```sql
Msg 109, Level 15, State 1, Line 374
There are more columns in the INSERT statement than values specified in the VALUES clause. The number of values in the VALUES clause must match the number of columns specified in the INSERT statement.

Completion time: 2025-05-18T15:15:40.6378761+04:00
```
I understand that this is because amount and method have constraint so amount should be > 0 and method can not be null.

## 7. Case 7:
I am trying to inserting a review for book that does not exist, member who was never registered by this command:
```sql
INSERT INTO Member_reviewed_books (Review_Date, ReviewID, MemberID, BookID) VALUES
('2025-05-05', 5, 49, 33);
```
but I am getting the following error:
```sql
Msg 547, Level 16, State 0, Line 381
The INSERT statement conflicted with the FOREIGN KEY constraint "FK__Member_re__Membe__72C60C4A". The conflict occurred in database "LibraryManagementSystem", table "dbo.Member", column 'MemberID'.
The statement has been terminated.

Completion time: 2025-05-18T15:26:54.4816036+04:00
```
I understand that this is because BookID and MemberID are FK in Member_reviewed_books so I will not be able to add new review for an exist book or member 
