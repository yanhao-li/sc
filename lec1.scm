Welcome to Racket v7.8.
R5RS legacy support loaded
> 
; This is a comment

;; The basic datatypes of scheme: numbers, symbols, strings, #t (true), #f (false)

3   ;; this is a number
3
> 4.5   ;; also a number 
4.5
> "this is a string"
"this is a string"

> ;;; Scheme also has symbols, which are objects whose only value is its name
'jonathan
jonathan

> #f  ;; this is how you write FALSE
#f

> #t ;; this is TRUE
#t

> ;;; In Scheme, lists are the primary composite data structure (composed of other things)

'(1 2 3 4)    ;; this list has four elements
(1 2 3 4)

> ;;; Lists can be heterogeneous, meaning they can have elements of different types.

'(bob 3 (4.5 "hello" sally) 7)  ;; this also has four elements, the third element is a nested list.
(bob 3 (4.5 "hello" sally) 7)


> ;;; Scheme is dynamically typed, meaning that type checking occurs as the program is
  ;;; running.

'()  ;;; this is the empty list
()
> 

;;; Defining variables

(define x 30)

> ;;; access a variable by just using its name

x
30

> (define y '(1 2 3 4 5))

> y
(1 2 3 4 5)

> 
;;; arithmetic expressions:  infix notation and parentheses  (op operand1 operand2 ...)

(+ 3 4)
7
> ;;; never write 3+4, only (+ 3 4)

(+ x 5)
35
> (+ (* x 2) 7)
67


> ;;; These expressions look just like the lists above!  How to indicate if you are typing
  ;;; a list, rather than an expression?  Use the quote: '

'(+ x 5)   ;;;; this is list containing the symbols + and x, and the number 5
(+ x 5)
> (+ x 5)   ;;;; no quote, so this is treated as code to evaluate.
35

> x
30

> 'x
x

> 'define
define

> 
;;; Defining functions: (define (fn param1 param2 ... paramN) body)

(define (f x y) (+ x y))
> (f 10 20)
30

> ;;; Since variables can't be overwritten, all functions return values -- otherwise there'd
  ;;; be no point to calling a function (except for I/O)

x
30

> ;;; Conditionals:    (if condition then-part else-part)

(if (= x 29) 'YES (+ x 15))
45

> ;;; Our first recursive function (yay!)

(define (fac n) (if (= n 0) 1 (* n (fac (- n 1)))))   ;;; factorial

> ;;; function call, like an operation, is written as (fn arg1 ... argn)

(fac 5)
120

> ;;; Another form of conditional:   (cond (cond1 result1) (cond2 result2) ... (condN resultN))

(cond ((= x 10) 'first)
      ((= x 30) 'second)
      (else 'third))     ;;; else always evaluates to true.
second
> ;;; rewriting fac using cond:

(define (fac x)
  (cond ((= x 0) 1)
        (else (* x (fac (- x 1))))))

> (fac 6)
720
> 

;;; Built-in functions for manipulating lists.

;;; CAR:  (car L) returns the first element of L.

(car '(2 4 6 8))
2
> y
(1 2 3 4 5)
> (car y)
1
> ;;; has y changed?  NO! Variables don't change their values in a functional language.
y
(1 2 3 4 5)
> 
;;; CDR:  (cdr L) returns a list containing all the elements of L except for the first element.

(cdr '(2 4 6 8))
(4 6 8)
> 

;;; Let's define the function (nth n L), which returns the n'th element of L.
;;; Example:  (nth 3 '(2 4 6 8 10))  => 6

;;; Recursive thinking:
;;;    Base case:  n=1 => return (car L)
;;;    Assumption:  nth works on any input less than n, e.g. (nth (- n 1) ...)
;;;    Step:  The nth element of L is the (n-1)th element of (cdr L)

(define (nth n L)
  (cond ((= n 1) (car L))
        (else (nth (- n 1) (cdr L)))))
> 

(nth 4 '(2 4 6 8 10))
8

