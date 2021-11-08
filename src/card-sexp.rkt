#lang racket

; cards-sexp ist dafür da, die Karten als s-expression zu verwalten.

;  /$$   /$$                       /$$                        
; | $$  /$$/                      | $$                        
; | $$ /$$/   /$$$$$$   /$$$$$$  /$$$$$$    /$$$$$$  /$$$$$$$ 
; | $$$$$/   |____  $$ /$$__  $$|_  $$_/   /$$__  $$| $$__  $$
; | $$  $$    /$$$$$$$| $$  \__/  | $$    | $$$$$$$$| $$  \ $$
; | $$\  $$  /$$__  $$| $$        | $$ /$$| $$_____/| $$  | $$
; | $$ \  $$|  $$$$$$$| $$        |  $$$$/|  $$$$$$$| $$  | $$
; |__/  \__/ \_______/|__/         \___/   \_______/|__/  |__/

; Alle Karten als s-expression und die leere Karte
(define card0  (list "0"     "0"      0   0))

(define card1  (list "Kreuz" "Ass"   11   1))
(define card2  (list "Kreuz" "10"    10   2))
(define card3  (list "Kreuz" "König"  4   3))
(define card4  (list "Kreuz" "Dame"   3   4))
(define card5  (list "Kreuz" "Bube"   2   5))
(define card6  (list "Kreuz" "9"      0   6))

(define card7  (list "Pik"   "Ass"   11   7))
(define card8  (list "Pik"   "10"    10   8))
(define card9  (list "Pik"   "König"  4   9))
(define card10 (list "Pik"   "Dame"   3  10))
(define card11 (list "Pik"   "Bube"   2  11))
(define card12 (list "Pik"   "9"      0  12))

(define card13 (list "Herz"  "Ass"   11  13))
(define card14 (list "Herz"  "10"    10  14))
(define card15 (list "Herz"  "König"  4  15))
(define card16 (list "Herz"  "Dame"   3  16))
(define card17 (list "Herz"  "Bube"   2  17))
(define card18 (list "Herz"  "9"      0  18))

(define card19 (list "Karo"  "Ass"   11  19))
(define card20 (list "Karo"  "10"    10  20))
(define card21 (list "Karo"  "König"  4  21))
(define card22 (list "Karo"  "Dame"   3  22))
(define card23 (list "Karo"  "Bube"   2  23))
(define card24 (list "Karo"  "9"      0  24))

; Leere Hand und leere Mitte
(define empty_hand (list card0 card0 card0 card0 card0 card0))
(define empty_middle (list card0 card0))

; Liste aller Karten
(define all-cards (list card1  card2  card3  card4  card5  card6  card7  card8  card9  card10 card11 card12
                        card13 card14 card15 card16 card17 card18 card19 card20 card21 card22 card23 card24))

; Alles exportieren
(provide (all-defined-out))