#!/usr/bin/env racket

#lang racket

(require odysseus)
(require tabtree)
(require tabtree/utils)
(require tabtree/globals)

(define (find-undeclared-keys)
  (let* (
        (tabtree (parse-tabtree "../source/main.tree"))
        (all-keys (->> tabtree hash-values (map remove-specials) (map hash-keys) flatten remove-duplicates))
        (special-ids (join (hash-keys aliases) reserved-predicates))
        (declared-ids (-> tabtree hash-keys)))
      (--- (list->pretty-string (minus all-keys (join declared-ids special-ids))))))

(find-undeclared-keys)
