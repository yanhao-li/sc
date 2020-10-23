Welcome to Racket v7.8.
R5RS legacy support loaded

> ;;; already covered CAR and CDR

(car '(2 4 6)) 
2
> (cdr '(2 4 6))
(4 6)
> (define x '(2 4 6 8 10))
> (cdr x) 
(4 6 8 10)
> x   ;; of course, car and cdr don't modify their parameters.
(2 4 6 8 10)

> ;;; second element of the list

(car (cdr x))
4

> ;;; third element

(car (cdr (cdr x)))
6

> ;;; Scheme gives shortcuts for common combinations of car and cdr.
  ;;; "c" followed by a string of a's and d's, followed by "r"
  ;;; where the pattern of a's and d's correspond to the pattern of car and cdr.

;;; CADR == (car (cdr ..))

(cadr x)     ;;; second element
4
> (caddr x)   ;; this is (car (cdr (cdr x))), so third element
6
> (cadar '((1 2) (3 4) (4 5)))  ;; the second element of the first  element.
2
> (car (cdr (car '((1 2) (3 4) (4 5)))))
2
> (car '((1 2) (3 4) (4 5)))
(1 2)
> (cdr (car '((1 2) (3 4) (4 5))))
(2)
> (car (cdr (car '((1 2) (3 4) (4 5)))))
2
> (cdr '(3))
()
> ;;; the empty list is pronounced "NIL"


;;; HOw do we construct lists?

;;; (1) using the quote notation 
'(1 2 3 4)
(1 2 3 4)
> 

;;; (2) using the LIST function -- which creates a list of its arguments, after they have been evaluated

(list 1 2 (* 3 4))
(1 2 12)
> 

;;; (3) using CONS  -- (cons x L) returns a new list containing x and all the elements of L (in that order)

(cons 3 '(6 9 12 15))
(3 6 9 12 15)
> 

x
(2 4 6 8 10)

> (cons 0 x)
(0 2 4 6 8 10)

> ;;; Has x changed  -- OF COURSE NOT, variables aren't modified in a functional language
x
(2 4 6 8 10)


> ;;; you can put anything in lists!

(cons '(hello there) '(how are you 2))
((hello there) how are you 2)

> ;;; The above list, cons) are the primitive functions for creating lists.  They can't
  ;;; themselves be written in Scheme, they have to be implemented in the underlying system.
  ;;; 
  ;;; There are other functions for creating new lists, but they are all constructed from cons and list.

;;; cons can only put something at the front of a list.
;;; Suppose we wanted to put something at the end of a list? We'd write a function to do it!
;;; It would have to return a new list, because existing lists can't be modified.

;;; Want to write (end x L) that returns a new list containing all the elements of L followed by x.
;;;   (end 4 '(1 2 3 5 6 7)) => '(1 2 3 5 6 7 4)

;; Recursive thinking!!!!
;;   Base case: L is empty, return the list containing x:   (list x)
;;   Assumption: Assume that (end x Lprime) works for any list Lprime smaller than L.
;;   Step:  Since (cdr L) is smaller than L, under the above assumption,  (end x (cdr L))
;;   returns exactly what we want, except the first element of L is missing. So, use cons
;;   to add the first element of L back in.

(define (end x L)
  (cond ((null? L) (list x))   ;; (null? L) returns true if L is nil (the empty list)
        (else (cons (car L) (end x (cdr L))))))
>  (end 4 '(1 2 3 5 6 7))
(1 2 3 5 6 7 4)
> 

;;;; Append is a pre-defined function,  (append L1 L2) returns a list containing all the elements
;;;; of L1 and all the elements of L2 (in that order). 

(append '(monday tues wed) '(thurs fri sat sun))
(monday tues wed thurs fri sat sun)
> ;;; of course, append does not modify its parameters

(append '(30 40 50) x)
(30 40 50 2 4 6 8 10)
> x
(2 4 6 8 10)

> ;;; It's easy to write your own append

(define (myappend L1 L2)
  (cond ((null? L1) L2)
        (else (cons (car L1) (myappend (cdr L1) L2)))))
> 

(myappend '(30 40 50) x)
(30 40 50 2 4 6 8 10)


>  ;;; Notice that append's complexity is O(N), i.e. linear in the size of its first parameter, L1.
   ;;; That's because it recurses down L1, so the number of calls to append is equal to the
   ;;; size of L1 -- and at each level of the recursion, only constant time functions (cons, car,
   ;;; and cdr) operations are performed.

;;; built-in reverse function

(reverse '(2 3 4 5 6))
(6 5 4 3 2)
> x
(2 4 6 8 10)
> (reverse x)
(10 8 6 4 2)
> x
(2 4 6 8 10)
> ;;; only reverses at the top level, not within nested lists

(reverse '((1 2 3) 4 5 6))
(6 5 4 (1 2 3))
> 

;;; reverse is easily written in Scheme

(define (myreverse L)
  (cond ((null? L) L)
        (else (append (myreverse (cdr L)) (list (car L))))))
> 
(myreverse '(3 4 5 6))
(6 5 4 3)
> (cons '(6 5 4) 3)
((6 5 4) . 3)
> 

;;; What's the complexity of myreverse?   N^2

;;; That's because myreverse is called N times, and each time, append is called (which is linear in
;;; its first parameter).

;;; first call to append is on n-1 elements, second call to append is on n-2 elements, etc. so
;;; cost is (n-1) + (n-2) + ...  =  n(n-1)/2 = O(n^2).

;;; Linear time reverse:   just copy the elements from one list to another, so that the 
;;;  first element of the old list ends up as the last element of the new list.

(define (rev L result)
  (cond ((null? L) result)
        (else (rev (cdr L) (cons (car L) result)))))
> 

(rev '(1 2 3 4) '())
(4 3 2 1)
> (define (mynewreverse L) (rev L '()))
> 
(mynewreverse '(2 4 6 8))
(8 6 4 2)
> 

;;; LET is used to introduce nested scopes (i.e. define local variables).

;;;   (let ((var1 exp1) ... (varN expN)) body)
;;;     - evaluates the body in a scope where var1 has the value of exp1, var2 has the value of exp2, etc.

(let ((a 20) (b 30)) (+ a b))
50
> ;;;; the scope of a and b is only within the body, (+ a b)

a
a: undefined;
 cannot reference an identifier before its definition
  in module: top-level
  context...:
   eval-one-top
   /Applications/Racket v7.8/collects/racket/repl.rkt:11:26
   "/Applications/Racket v7.8/share/pkgs/r5rs-lib/r5rs/run.rkt": [running body]
   temp35_0
   for-loop
   run-module-instance!
   perform-require!


> ;;; this also means that each expi cannot use any of the new variables introduced by the let.

(let ((a 20) (b (+ a 10))) (+ a b))
a: undefined;
 cannot reference an identifier before its definition
  in module: top-level
  context...:
   eval-one-top
   /Applications/Racket v7.8/collects/racket/repl.rkt:11:26
   "/Applications/Racket v7.8/share/pkgs/r5rs-lib/r5rs/run.rkt": [running body]
   temp35_0
   for-loop
   run-module-instance!
   perform-require!
> 

x
(2 4 6 8 10)

> (let ((x '(100 200)) (y (car x)))    ;; here, the x referred to in (car x) is the outer x, above.
     (+ y 5))
7
> 

> ;; if you want the value of a new variable to depend on a previous new variable, you can
  ;; have nested LET's.
  
(let ((a 20))
  (let ((b (+ a 1)))
     (+ a b)))
41


> ;;; or, use LET*, which is equivalent to nesting LET's

(let* ((a 20) (b (+ a 10))) (+ a b))   ;; b's value can depend on a here.
50
> 

;;; Functions are first class!  They are values that can be passed, returned, stored, etc.

(define (f x) (+ x 1))
> (f 3)
4
> 

(define (g h)    ;;; Notice h must be a function parameter, since it gets called.
   (h 7))
> 

(g f)   ;; here, f the actual parameter corresponding to the formal parameter h, so
        ;; when (h 7) is called, above, it's actually f being called.
8

> ;;; g is a "higher order function" because it operates on other functions.

;;; MAP:  (map f L) returns a list whose elements are the results of calling f on each element of L.

(define (double x) (* x 2))
> 

(map double '(1 3 5 7 9))   ;; this calls the double function, above, on each element of the list.
(2 6 10 14 18)
> 

;;; easy to write map

(define (mymap f L)
  (cond ((null? L) '())
        (else (cons (f (car L)) (mymap f (cdr L))))))
> 

(mymap double '(1 3 5 7 9))
(2 6 10 14 18)
> 

;;; suppose I wanted to use map to triple every element of a list?

(define (triple x) (* x 3))
> (map triple '(1 2 3 5 7))
(3 6 9 15 21)

> ;;; suppose I never need to use triple again? It was a waste to have to come up with a new name and define a new function!

;;; we can express anonymous functions -- (lambda (param1 ... paramN) body)
;;; the value of that expression is function that has no name, has the parameters param1 ... paramN, and the specified body.

(map (lambda (x) (+ x 100)) '(1 2 3 4))    ;; here the value of the lambda is a function that takes
                                           ;; a single parameter x and returns x+100.
(101 102 103 104)
> 
;;; I can put functions in lists

(define mylist (list double triple (lambda (y) (* y 4))))   ;; this list contains three functions.
> mylist
(#<procedure:double> #<procedure:triple> #<procedure>)
> 
(map (lambda (f) (f 7)) mylist)    ;;; look closely, can you figure out why this result is generated?
(14 21 28)
> 

;;; functions can be returned as values

(define (f x)        
  (cond ((equal? x 10) (lambda (y) (* y 2)))   ;; in either case, the result of (f x) is itself a function.
        (else (lambda (y) (* y 7)))))
> 
> 
#<procedure:>>
> 
(f 10)   ;; the result of calling (f 10) is the function defined by (lambda (y) (* y 2))
#<procedure>
> (f 11)   ;; the result of calling (f 11) is the function defined by (lambda (y) (* y 7))

> ((f 10) 5)    ;; here, the function returned by (f 10) is then called on 5.
10


>   ;;; A student asked how to express not-equal:
(not (equal? 4 5))
#t

;; For numbers, you can also use "=" to test equality.
> (= 4 5)
#f
> (not (= 4 5))
#t
> (cond ((= 4 5) 5)
        ((< 4 5) 4)
        (else 3))
4
> (if (= 4 5) 3 (if (< 4 5) 4 3))
4


>  ;; A student asked about, in the context of (map f L), what happens if there is a
   ;; mismatch between what f is expecting and the type of element in L.

(map reverse '(1 2 3 4))
mcdr: contract violation
  expected: mpair?
  given: 1
  context...:
   /Applications/Racket v7.8/share/pkgs/compatibility-lib/compatibility/mlist.rkt:147:0: mreverse
   eval-one-top
   /Applications/Racket v7.8/collects/racket/repl.rkt:11:26
   "/Applications/Racket v7.8/share/pkgs/r5rs-lib/r5rs/run.rkt": [running body]
   temp35_0
   for-loop
   run-module-instance!
   perform-require!


>  ;; if the function is reverse, the list has to be a list of lists.

(map reverse '((1 2) (3 4) (5 6 7)))
((2 1) (4 3) (7 6 5))

