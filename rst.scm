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

;; 4. 