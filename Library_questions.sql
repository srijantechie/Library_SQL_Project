select * from books;
select * from branch;
select * from employees;
select * from issued_status;
select * from members;
select * from return_status;
										--TASK--

--TASK:1   Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books(isbn,book_title,category,rental_price,status,author,publisher)
values
('978-1-60129-456-2','To Kill a Mockingbird','Classic', '6.00', 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
select * from books;

-- Task 2: Update an Existing Member's Address
update  members
set member_address = '123 Main bt'
where member_id='C101';
select * from members;

--Task:3 Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table

DELETE  from  issued_status
where issued_id='IS121';

--Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

select issued_book_name from issued_status
where  issued_emp_id='E101';

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

select  ist.issued_emp_id, e.emp_name, count(ist.issued_id)
 from issued_status as ist 
JOIN employees as e 
on ist.issued_emp_id = e.emp_id
group by 1,2
having count(ist.issued_id)>1

-- Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

create table book_cnts
	as 
	(
select     b.isbn , b.book_title ,  count(ist.issued_id) as issued_book_counts
from books as b 
Join issued_status as ist 
on b.isbn=ist.issued_book_isbn
group by 1 , 2 
);
select * from book_cnts;


-- Task 7. Retrieve All Books in a Specific Category:

select * from  books 
where category='Classic';



-- Task 8: Find Total Rental Income by Category:
SELECT
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1;

-- Task 9:List Members Who Registered in the Last 180 Days:
SELECT * FROM members
WHERE reg_date < CURRENT_DATE - INTERVAL '180 days' ;   

    
-- task 10: List Employees with Their Branch Manager's Name and their branch details:

SELECT 
    e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM employees as e1
JOIN  
branch as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON b.manager_id = e2.emp_id;


-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
create table books_price_greater_than_7
	as 
select * from  books 
where rental_price>7;
select * from books_price_greater_than_7;


-- Task 12: Retrieve the List of Books Not Yet Returned

select 
	Distinct(ist.issued_book_name)
from issued_status as ist
 left join return_status as rs
on   ist.issued_id= rs.issued_id
 where return_book_isbn is null;

