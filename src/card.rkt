#lang racket
(require "graphics.rkt")

; Graphics ist dafür da, alle Karten als struct zu verwalten.

;  /$$   /$$                       /$$                        
; | $$  /$$/                      | $$                        
; | $$ /$$/   /$$$$$$   /$$$$$$  /$$$$$$    /$$$$$$  /$$$$$$$ 
; | $$$$$/   |____  $$ /$$__  $$|_  $$_/   /$$__  $$| $$__  $$
; | $$  $$    /$$$$$$$| $$  \__/  | $$    | $$$$$$$$| $$  \ $$
; | $$\  $$  /$$__  $$| $$        | $$ /$$| $$_____/| $$  | $$
; | $$ \  $$|  $$$$$$$| $$        |  $$$$/|  $$$$$$$| $$  | $$
; |__/  \__/ \_______/|__/         \___/   \_______/|__/  |__/

; Aufbau einer Karte
(struct card (type name value sort-value image back) #:transparent)

; Alle Karten als structs und eine leere Karte
(define card0  (card "0"     "0"      0   0 EMPTY    EMPTY))

(define card1  (card "Kreuz" "Ass"   11   1 KREUZ-A   BACK))
(define card2  (card "Kreuz" "10"    10   2 KREUZ-10  BACK))
(define card3  (card "Kreuz" "König"  4   3 KREUZ-K   BACK))
(define card4  (card "Kreuz" "Dame"   3   4 KREUZ-D   BACK))
(define card5  (card "Kreuz" "Bube"   2   5 KREUZ-B   BACK))
(define card6  (card "Kreuz" "9"      0   6 KREUZ-9   BACK))

(define card7  (card "Pik"   "Ass"   11   7 PIK-A   BACK))
(define card8  (card "Pik"   "10"    10   8 PIK-10  BACK))
(define card9  (card "Pik"   "König"  4   9 PIK-K   BACK))
(define card10 (card "Pik"   "Dame"   3  10 PIK-D   BACK))
(define card11 (card "Pik"   "Bube"   2  11 PIK-B   BACK))
(define card12 (card "Pik"   "9"      0  12 PIK-9   BACK))

(define card13 (card "Herz"  "Ass"   11  13 HERZ-A   BACK))
(define card14 (card "Herz"  "10"    10  14 HERZ-10  BACK))
(define card15 (card "Herz"  "König"  4  15 HERZ-K   BACK))
(define card16 (card "Herz"  "Dame"   3  16 HERZ-D   BACK))
(define card17 (card "Herz"  "Bube"   2  17 HERZ-B   BACK))
(define card18 (card "Herz"  "9"      0  18 HERZ-9   BACK))

(define card19 (card "Karo"  "Ass"   11  19 KARO-A   BACK))
(define card20 (card "Karo"  "10"    10  20 KARO-10  BACK))
(define card21 (card "Karo"  "König"  4  21 KARO-K   BACK))
(define card22 (card "Karo"  "Dame"   3  22 KARO-D   BACK))
(define card23 (card "Karo"  "Bube"   2  23 KARO-B   BACK))
(define card24 (card "Karo"  "9"      0  24 KARO-9   BACK))

; card (s-expression) --> card (struct)
; Bekommt eine Karte (s-expression) und gibt die dazugehörige Karte (struct) zurück
(define (decode-string s-expr)
  (cond
    [(and (equal? (first s-expr) "0")     (equal? (second s-expr) "0"))     card0]
    
    [(and (equal? (first s-expr) "Kreuz") (equal? (second s-expr) "Ass"))   card1]
    [(and (equal? (first s-expr) "Kreuz") (equal? (second s-expr) "10"))    card2]
    [(and (equal? (first s-expr) "Kreuz") (equal? (second s-expr) "König")) card3]
    [(and (equal? (first s-expr) "Kreuz") (equal? (second s-expr) "Dame"))  card4]
    [(and (equal? (first s-expr) "Kreuz") (equal? (second s-expr) "Bube"))  card5]
    [(and (equal? (first s-expr) "Kreuz") (equal? (second s-expr) "9"))     card6]

    [(and (equal? (first s-expr) "Pik")   (equal? (second s-expr) "Ass"))   card7]
    [(and (equal? (first s-expr) "Pik")   (equal? (second s-expr) "10"))    card8]
    [(and (equal? (first s-expr) "Pik")   (equal? (second s-expr) "König")) card9]
    [(and (equal? (first s-expr) "Pik")   (equal? (second s-expr) "Dame"))  card10]
    [(and (equal? (first s-expr) "Pik")   (equal? (second s-expr) "Bube"))  card11]
    [(and (equal? (first s-expr) "Pik")   (equal? (second s-expr) "9"))     card12]

    [(and (equal? (first s-expr) "Herz")  (equal? (second s-expr) "Ass"))   card13]
    [(and (equal? (first s-expr) "Herz")  (equal? (second s-expr) "10"))    card14]
    [(and (equal? (first s-expr) "Herz")  (equal? (second s-expr) "König")) card15]
    [(and (equal? (first s-expr) "Herz")  (equal? (second s-expr) "Dame"))  card16]
    [(and (equal? (first s-expr) "Herz")  (equal? (second s-expr) "Bube"))  card17]
    [(and (equal? (first s-expr) "Herz")  (equal? (second s-expr) "9"))     card18]
    
    [(and (equal? (first s-expr) "Karo")  (equal? (second s-expr) "Ass"))   card19]
    [(and (equal? (first s-expr) "Karo")  (equal? (second s-expr) "10"))    card20]
    [(and (equal? (first s-expr) "Karo")  (equal? (second s-expr) "König")) card21]
    [(and (equal? (first s-expr) "Karo")  (equal? (second s-expr) "Dame"))  card22]
    [(and (equal? (first s-expr) "Karo")  (equal? (second s-expr) "Bube"))  card23]
    [(and (equal? (first s-expr) "Karo")  (equal? (second s-expr) "9"))     card24]))

; cards (List<s-expression>) --> cards (List<struct>)
; Bekommt eine Liste an Karten (s-expressions) und gibt eine Liste an Karten (structs) zurück
(define (decode-strings s-expr-list)
  (map decode-string s-expr-list))

; Leere Hand und leere Mitte
(define empty_hand (list card0 card0 card0 card0 card0 card0))
(define empty_middle (list card0 card0))

; Liste mit allen Karten
(define all-cards (list card1  card2  card3  card4  card5  card6
                        card7  card8  card9  card10 card11 card12
                        card13 card14 card15 card16 card17 card18
                        card19 card20 card21 card22 card23 card24))

; Alles exportieren
(provide (all-defined-out))