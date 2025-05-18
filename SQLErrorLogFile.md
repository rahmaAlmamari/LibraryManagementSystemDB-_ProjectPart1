#  **SQL Error Log File**

1. Case 1:
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