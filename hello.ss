(suppress-greeting #t)

(scheme-start
  (lambda args
    (cond
      [(null? args)
        (display "hello, world!\n")]
      [else
        (for-each (lambda (a) (printf "hello, ~a!~n" a)) args)])))
