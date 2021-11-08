#lang racket

; Accessors ist dafür da, zugriffe auf die verschiedenen Elemente in der Welt und im Universum zu verwalten.

;  /$$$$$$$$                               /$$  /$$$$$$   /$$$$$$         
; |_____ $$                               |__/ /$$__  $$ /$$__  $$        
;      /$$/  /$$   /$$  /$$$$$$   /$$$$$$  /$$| $$  \__/| $$  \__//$$$$$$ 
;     /$$/  | $$  | $$ /$$__  $$ /$$__  $$| $$| $$$$    | $$$$   /$$__  $$
;    /$$/   | $$  | $$| $$  \ $$| $$  \__/| $$| $$_/    | $$_/  | $$$$$$$$
;   /$$/    | $$  | $$| $$  | $$| $$      | $$| $$      | $$    | $$_____/
;  /$$$$$$$$|  $$$$$$/|  $$$$$$$| $$      | $$| $$      | $$    |  $$$$$$$
; |________/ \______/  \____  $$|__/      |__/|__/      |__/     \_______/
;                      /$$  \ $$                                          
;                     |  $$$$$$/                                          
;                      \______/

; Welt-Zustand & Universum-Zustand
;  1. Letzter-Spieler         Symbol
;  2. Hand P1                 List<card>
;  3. Hand P2                 List<card>
;  4. Stiche P1               List<card>
;  5. Stiche P1 Punkte        Number
;  6. Stiche P2               List<card>
;  7. Stiche P2 Punkte        Number
;  8. Mitte                   List<card>
;  9. Deck                    List<card>
; 10. Letzter Stich           List<card>
; 11. Wer hat zugemacht       Symbol
; 12. Gewinnpunkte P1         Number
; 13. Gewinnpunkte P2         Number
; 14. Trumpf                  String

; Universum-spezifische Zustände
; 15. Alle Welten (univ)      List 

; Schnellzugriff auf beide
(define (_state _)
  (first _))
(define (first-hand _)
  (second _))
(define (second-hand _)
  (third _))
(define (first-stich _)
  (fourth _))
(define (first-stich-points _)
  (fifth _))
(define (second-stich _)
  (sixth _))
(define (second-stich-points _)
  (seventh _))
(define (middle _)
  (eighth _))
(define (deck _)
  (ninth _))
(define (recent-stich _)
  (tenth _))
(define (who-closed _)
  (list-ref _ 10))
(define (gamepoints-p1 _)
  (list-ref _ 11))
(define (gamepoints-p2 _)
  (list-ref _ 12))
(define (trump _)
  (list-ref _ 13))
(define (wrld-names _)
  (list-ref _ 14))

; Universum-spezifisch
(define (current-worlds univ)
  (list-ref univ 15))
(define (world1 _)
  (first (current-worlds _)))
(define (world2 _)
  (second (current-worlds _)))

; Alles exportieren
(provide (all-defined-out))
