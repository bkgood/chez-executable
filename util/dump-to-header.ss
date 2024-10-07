#!/usr/bin/scheme --script

(define-syntax thunk
  (syntax-rules ()
    [(_ expr ...) (lambda _ expr ...)]))

(define (parse-opts args)
  (with-exception-handler
    (lambda (_) ; should be more sensitive; alas this arg parsing is already lackluster.
      (display (current-error-port) "usage: input symbol-name output")
      (exit 1))
    (lambda () (values (car args) (cadr args) (caddr args)))))

(define-values (infile name outfile) (parse-opts (cdr (command-line))))

;; make the byte look like what xxd produces, to make it easier to verify the
;; script does what I need.
(define (format-hex-byte x)
  (string-downcase
    (if (= 1 (string-length x))
      (string-append "0" (substring x 0 1))
      x)))

(define (process from into)
  (define break-every 12) ; xxd compat
  (define (next) (get-u8 from))

  (printf "unsigned char ~a[] = {~n" name)
  (let loop ([byte (next)]
             [written 0])
    (cond
      [(eof-object? byte)
        (display "\n};\n\n" into)
        (format into "size_t ~a_len = ~a;~n" name written)]
      [else
        (when (zero? (modulo written break-every))
          (display "  " into))
        (format into "0x~a," (format-hex-byte (number->string byte 16)))
        (if (zero? (modulo (add1 written) break-every))
          (display "\n" into)
          (display " " into))
        (loop (next) (add1 written))])))

(with-output-to-file outfile
  (thunk
    (let ([in (open-file-input-port infile)])
      (process in (current-output-port))
      (close-port in)))
  (list 'replace))
