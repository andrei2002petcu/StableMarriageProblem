#lang racket

(require "etapa2.rkt")

(provide (all-defined-out))

; TODO 1
; După modelul funcției stable-match?, implementați funcția
; get-unstable-couples care primește o listă de logodne
; engagements, o listă de preferințe masculine mpref și o 
; listă de preferințe feminine wpref, și întoarce lista
; tuturor cuplurilor instabile din engagements.
; Precizări (aspecte care se garantează, nu trebuie verificate):
; - fiecare cuplu din lista engagements are pe prima poziție
;   o femeie
; Nu este permisă recursivitatea pe stivă.
; Nu sunt permise alte funcții ajutătoare decât
; better-match-exists? și funcțiile de manipulare a listelor de
; preferințe definite în etapele anterioare.
; Nu este permisă apelarea multiplă a aceleiași funcții pe
; aceleași argumente.
; Folosiți una sau mai multe dintre expresiile let, let*, letrec,
; named let pentru a vă putea conforma acestor restricții.
(define (get-unstable-couples engagements mpref wpref)
  (define couples-wfirst engagements)
  (define couples-mfirst (foldl (lambda (x L) (cons (cons (cdr x) (car x)) L)) '() engagements))
  (let loop ((engagements engagements) (unstable-couples '()))
    (if (null? engagements)
        unstable-couples
        (let* ((current (car engagements)) (next (cdr engagements)) (p1 (car current)) (p2 (cdr current)))
          (if (or (better-match-exists? p2 p1 (get-pref-list mpref p2) wpref couples-wfirst)
                  (better-match-exists? p1 p2 (get-pref-list wpref p1) mpref couples-mfirst))
              (loop next (cons current unstable-couples))
              (loop next unstable-couples))))))

; TODO 2
; Implementați funcția engage care primește o listă free-men
; de bărbați încă nelogodiți, o listă de logodne parțiale 
; engagements (unde fiecare cuplu are pe prima poziție o femeie),
; o listă de preferințe masculine mpref și o listă de preferințe 
; feminine wpref, și întoarce o listă completă de logodne stabile,
; obținută conform algoritmului Gale-Shapley:
; - cât timp există un bărbat m încă nelogodit
;   - w = prima femeie din preferințele lui m pe care m nu a cerut-o încă
;   - dacă w este nelogodită, adaugă perechea (w, m) la engagements
;   - dacă w este logodită cu m'
;     - dacă w îl preferă pe m lui m'
;       - m' devine liber
;       - actualizează partenerul lui w la m în engagements
;     - altfel, repetă procesul cu următoarea femeie din lista lui m
; Folosiți named let pentru orice proces recursiv ajutător (deci nu
; veți defini funcții ajutătoare recursive).
; Folosiți let și/sau let* pentru a evita calcule duplicate.
(define (engage free-men engagements mpref wpref)
  (let loop-free-men ((free-men free-men) (engagements engagements))
    (if (null? free-men)
        engagements
        (let ((man (car free-men)))
          (let loop-w ((man-list (get-pref-list mpref man)))
            (let* ((woman (car man-list)) (husband (get-partner engagements woman)))
              (if (equal? husband #f)
                  (loop-free-men (cdr free-men) (cons (cons woman man) engagements))
                  (if (preferable? (get-pref-list wpref woman) man husband)
                      (loop-free-men (cons husband (cdr free-men)) (update-engagements engagements woman man))
                      (loop-w (cdr man-list))))))))))

; TODO 3
; Implementați funcția gale-shapley care este un wrapper pentru
; algoritmul implementat de funcția engage. Funcția gale-shapley
; primește doar o listă de preferințe masculine mpref și o listă
; de preferințe feminine wpref și calculează o listă completă de
; logodne stabile conform acestor preferințe.
(define (gale-shapley mpref wpref)
  (engage (get-men mpref) '() mpref wpref))

; TODO 4
; Implementați funcția get-couple-members care primește o listă
; de perechi cu punct și întoarce o listă simplă cu toate elementele 
; care apar în perechi.
; Folosiți funcționale, fără recursivitate explicită.
(define (get-couple-members pair-list)
  (foldl (lambda (x L) (append (list (car x)) (list (cdr x)) L)) '() pair-list))
