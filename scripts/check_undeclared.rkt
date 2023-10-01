#!/usr/bin/env racket

#lang racket

(require odysseus)
(require tabtree)
(require tabtree/utils)
(require tabtree/globals)

(define predicates (make-parameter (hash)))
(define tabtree (parse-tabtree "/home/denis/projects/semtech_kgr/source/main.tree"))

(define-catch (find-undeclared-predicates tabtree)
  (let* (
        (all-keys (->> tabtree hash-values (map remove-specials) (map hash-keys) flatten remove-duplicates (filter-not namespaced?)))
        (special-ids (join (hash-keys aliases) reserved-predicates))
        (declared-ids (-> tabtree hash-keys)))
    (minus all-keys (join declared-ids special-ids))))

(define-catch (find-undeclared-objects tabtree)
  (let* ((all-p-o (->> tabtree hash-values (map remove-specials) (apply hash-union-merge)))
        (not-literal-p-o
          (for/fold
            ((res (hash)))
            (((k vs) all-p-o))
            (if (or
                (literal-predicate? k tabtree)
                (index-of? (list "alt") k))
              res
              (hash-union res (hash k vs)))))
        (not-literal-os (->> not-literal-p-o hash-values flatten remove-duplicates))
        (declared-ids (-> tabtree hash-keys))
        (alias-ids (hash-keys aliases))
        (namespaced-ids (filter namespaced? not-literal-os)))
    (minus (minus not-literal-os (join namespaced-ids alias-ids)) declared-ids)))

(--- "Undefined predicates:" (list->pretty-string (find-undeclared-predicates tabtree)))
(--- "Undefined objects:" (list->pretty-string (find-undeclared-objects tabtree)))
