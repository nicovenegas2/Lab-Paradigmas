#lang racket

(provide (all-defined-out))
(define encryptFn (lambda (s) (list->string (reverse (string->list s)))))