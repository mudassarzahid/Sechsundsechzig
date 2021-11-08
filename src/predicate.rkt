#lang racket

;  /$$$$$$$            /$ /$         /$$ /$$ /$$                   /$$              
; | $$__  $$          |_/|_/        | $$|__/| $$                  | $$              
; | $$  \ $$ /$$$$$$  /$$$$$$   /$$$$$$$ /$$| $$   /$$  /$$$$$$  /$$$$$$    /$$$$$$ 
; | $$$$$$$//$$__  $$|____  $$ /$$__  $$| $$| $$  /$$/ |____  $$|_  $$_/   /$$__  $$
; | $$____/| $$  \__/ /$$$$$$$| $$  | $$| $$| $$$$$$/   /$$$$$$$  | $$    | $$$$$$$$
; | $$     | $$      /$$__  $$| $$  | $$| $$| $$_  $$  /$$__  $$  | $$ /$$| $$_____/
; | $$     | $$     |  $$$$$$$|  $$$$$$$| $$| $$ \  $$|  $$$$$$$  |  $$$$/|  $$$$$$$
; |__/     |__/      \_______/ \_______/|__/|__/  \__/ \_______/   \____/  \_______/

; hand (List<card>) --> boolean
; Gibt es ein Kreuz-Paar in der Hand?
(define (kreuz-paar? hand)
  (and (member (list "Kreuz" "Dame" 3 4) hand)
       (member (list "Kreuz" "König" 4 3) hand)))

; hand (List<card>) --> boolean
; Gibt es ein Pik-Paar in der Hand?
(define (pik-paar? hand)
  (and (member (list "Pik" "Dame" 3 10)  hand)
       (member (list "Pik" "König" 4 9)   hand)))

; hand (List<card>) --> boolean
; Gibt es ein Herz-Paar in der Hand?
(define (herz-paar? hand)
  (and (member (list "Herz" "Dame" 3 16) hand)
       (member (list "Herz" "König" 4 15) hand)))

; hand (List<card>) --> boolean
; Gibt es ein Karo-Paar in der Hand?
(define (karo-paar? hand)
  (and (member (list "Karo" "Dame" 3 22) hand)
       (member (list "Karo" "König" 4 21) hand)))

; hand (List<card>) --> boolean
; Gibt es eine normale Hochzeit (keine Trumpfhochzeit) in der Hand?
(define (regular-hochzeit? trump hand)
  (or (and (kreuz-paar? hand) (not (equal? trump "Kreuz")))
      (and (pik-paar?   hand) (not (equal? trump "Pik")))
      (and (herz-paar?  hand) (not (equal? trump "Herz")))
      (and (karo-paar?  hand) (not (equal? trump "Karo")))))

; hand (List<card>) --> boolean
; Gibt es ein Trumpf Paar in der Hand?
(define (trump-hochzeit? trump hand)
  (or (and (kreuz-paar? hand) (equal? trump "Kreuz"))
      (and (pik-paar?   hand) (equal? trump "Pik"))
      (and (herz-paar?  hand) (equal? trump "Herz"))
      (and (karo-paar?  hand) (equal? trump "Karo"))))

; card (s-expression) --> boolean
; Ist diese Karte eine Kreuz-Neun?
(define (kreuz-neun? card)
  (and (equal? (first card) "Kreuz")
       (equal? (second card) "9")))

; card (s-expression) --> boolean
; Ist diese Karte eine Pik-Neun?
(define (pik-neun? card)
  (and (equal? (first card) "Pik")
       (equal? (second card) "9")))

; card (s-expression) --> boolean
; Ist diese Karte eine Herz-Neun?
(define (herz-neun? card)
  (and (equal? (first card) "Herz")
       (equal? (second card) "9")))

; card (s-expression) --> boolean
; Ist diese Karte eine Karo-Neun?
(define (karo-neun? card)
  (and (equal? (first card) "Karo")
       (equal? (second card) "9")))

; hand (List<cards>), selected_card (s-expression) --> boolean
; Ist meine ausgewählte Karte zum Legen teil eines Pärchens, das ich besitze
(define (paar? hand selected_card)
  (or
   (and (kreuz-paar? hand)
        (equal? (first selected_card) "Kreuz")
        (or (equal? (second selected_card) "König") (equal? (second selected_card) "Dame")))
   
   (and (herz-paar?  hand)
        (equal? (first selected_card) "Herz")
        (or (equal? (second selected_card) "König") (equal? (second selected_card) "Dame")))
   
   (and (pik-paar? hand)
        (equal? (first selected_card) "Pik")
        (or (equal? (second selected_card) "König") (equal? (second selected_card) "Dame")))
   
   (and (karo-paar? hand)
        (equal? (first selected_card) "Karo")
        (or (equal? (second selected_card) "König") (equal? (second selected_card) "Dame")))))

; middle (List<cards>), hand (List<cards>) --> boolean
; Gibt es auf der Hand mindestens eine Karte, die dieselbe Farbe hat wie die zuvor gelegte Karte
(define (same-color? middle hand)
  (foldl (lambda (x y) (or x y)) #f
         (map (lambda (x) (equal? (first x) (first (first middle)))) hand)))

; state (constant) --> boolean
; Darf ich zurzeit spielen?
(define (can-play? state)
  (member state (list 'won 'forceWon 'play 'forcePlay
                      'announce 'forceAnnounce 'announceTrump 'forceAnnounceTrump)))

; state (constant) --> boolean
; Hat ein Spieler endgültig gewonnen?
(define (won? state)
  (member state (list 'Won3t 'cWon3t 'cWon3f 'Won3f 'Won2t 'cWon2t 'Won1t 'cWon1t 'wonLast)))

; state (constant) --> boolean
; Hat ein Spieler endgültig verloren?
(define (lost? state)
  (member state (list 'Lost3t 'cLost3t 'cLost3f 'Lost3f 'Lost2t 'cLost2t 'Lost1t 'cLost1t 'lostLast)))

; state (constant) --> boolean
; Ein predicate, um zu checken, ob die Welt sich in einem Endzustand befindet
(define (end-state? state)
  (or (won? state) (lost? state)))

(provide (all-defined-out))