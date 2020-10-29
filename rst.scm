
;; 1. (fromTo k n) returns the list of integers from k to n, inclusive.
;; Base case: if k > 0 return empty list
;; Assumption: Assume (fromTo (+ k 1) n) works
;; Step: (fromTo k n) = (cons k fromTo (+ k 1) n)
(define (fromTo k n)
  (cond ((> k n) '())
        (else (cons k (fromTo (+ k 1) n)))))

;; 2. (removeMults m L) returns a list containing all the elements of L that are not multiples of m.
;; Base Case: L is empty, return empty list
;; Assumption: (removeMults m (cdr L)) works
;; Step:: check if (cars L) multiple of m, if it isn't, return (cons (cars L) (removeMults m (cdr L))), otherwise, return (removeMults m (cdr L)) directly
(define (removeMults m L)
  (cond ((null? L) '())
        (else (cond ((= (modulo (car L) m) 0) (removeMults m (cdr L)))
                    (else (cons (car L) (removeMults m (cdr L))))))))

;; 3. (removeAllMults L) which, given a list L containing integers in strictly increasing order,
;; returns a list containing those elements of L that are not multiples of each other.
;; Base Case: L is empty, return empty list
;; Assumption: (removeAllMults (cdr L)) works
;; Step: since (removeAllMults (cdr L)) will return the correct result except that it include the multiples of (car L),
;; we could use the pre-defined (removeMults) to remove those items
(define (removeAllMults L)
  (cond ((null? L) '())
        (else (cons (car L) (removeMults (car L) (removeAllMults (cdr L)))))))

;; 4. (primes n) computes the list of all primes less than or equal to n.
(define (primes n)
  (removeAllMults (fromTo 2 n)))

;; 5. (maxDepth L) returns the maximum nesting depth of any element within L, such that the topmost elements are at depth 0
;; Basecase: L is empty, return 0, if L is a single element, return 0
;; Assumption: maxDepth works for (cdr L) and (car L)
;; Step: 1. Compute (maxDepth (cdr L)) and (maxDepth (car L))
;;       2. Check if (car L) is a single element, if it is, return the result of (maxDepth (cdr L))
;;       2. if it isn't, compare the 1 + result of (maxDepth (car L)), with the of (maxDepth (cdr L)).
;;       3. return the larger result
(define (maxDepth L)
  (cond ((null? L) 0)
        ((integer? L) 0)
        (else (let ((a (maxDepth (car L))) (b (maxDepth (cdr L))))
           (cond ((integer? (car L)) b)
                 (else (cond ((> (+ a 1) b) (+ a 1))
                             (else b))))))))

;; 6. (prefix exp) transforms an infix arithmetic expression exp into prefix notation
;; Basecase: exp is empty or a single integer, return the exp.
;; Assumption: for an exp (a opertor b), (prefix a) and (prefix b) works well
;; Step: Reconstruct the list '((caar exp) (prefix (car exp)) (prefix (cddr exp)))

(define (prefix exp)
  (cond ((null? exp) exp)
        ((integer? exp) exp)
        ((null? (cdr exp)) (car exp))
        (else (list (cadr exp) (prefix (car exp)) (prefix (cddr exp))))))

;; 7.(composition fns) takes a list of functions fns and returns a function that is the composition of the functions in fns.
;; Basecase: fns only contains one function, return that function
;; Assumption: (composition cdr(fns)) works correctly
;; Step: Return the function f(x)=((car fns) cdr(fns))
;; Question: why last line can't just be  (else ((car fns) ((composition (cdr fns))))?
(define (composition fns)
  (cond ((null? (cdr fns)) (car fns))
        (else (lambda(x) ((car fns) ((composition (cdr fns)) x))))))

;; 8. (bubble-to-n L N) takes a list of numbers L, and an integer N, return a list containing all elements of L,
;; except that the largest element among the first N elements of L is now the Nth element of the resulting list
;; Basecase: if N is less than 2 or L has no more than 1 element, return L
;; Assumption: (bubble-to-n (cdr L) (- N 1)) works correctly
;; Step: Compare (car L) with the second element of list, if first element is smaller, cons the first element onto the result of (bubble-to-n (cdr L) (- N 1))
;; Otherwise the second element will be the first one, cons it with the result of (bubble-to-n (cons (car L) (cddr L)) (- N 1))

(define (bubble-to-n L N)
  (cond ((null? (cdr L)) L)
        ((< N 2) L)
        (else (cond ((< (car L) (cadr L)) (cons (car L) (bubble-to-n (cdr L) (- N 1))))
                    (else (cons (cadr L) (bubble-to-n (cons (car L) (cddr L)) (- N 1))))))))

;; 9. (b-s L N) returns the a list containing the elements of L in their original order except that the first N elements are in sorted order.
;; Basecase: if L is empty or N equal to 0, retunr L
;; Assumption: (b-s L (- N 1)) works correctly
;; Step: firstly using (bubble-to-n L N) to put the correct number onto index N, then recursively call (b-s L (- N 1)) to sort the rest N - 1 items.
(define (b-s L N)
  (cond ((null? L) L)
        ((equal? N 0) L)
        (else (b-s (bubble-to-n L N) (- N 1)))))

;; 10. (bubble-sort L) return L in sorted order
(define (bubble-sort L)
  (b-s L (length L)))
