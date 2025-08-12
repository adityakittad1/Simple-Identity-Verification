;; Simple Identity Verification Contract

;; Data map to store user identities
;; principal -> { name, id-hash }
(define-map identities principal 
  {
    name: (string-ascii 50),
    id-hash: (buff 32)
  }
)

;; Error constants
(define-constant err-already-registered (err u100))
(define-constant err-not-found (err u101))
(define-constant err-invalid-data (err u102))

;; Function 1: Register Identity
(define-public (register-identity (name (string-ascii 50)) (id-hash (buff 32)))
  (begin
    ;; Ensure valid data
    (asserts! (> (len name) u0) err-invalid-data)
    ;; Check if user already registered
    (asserts! (is-none (map-get? identities tx-sender)) err-already-registered)
    ;; Store identity
    (map-set identities tx-sender {name: name, id-hash: id-hash})
    (ok true)
  )
)

;; Function 2: Verify Identity
(define-read-only (verify-identity (user principal))
  (match (map-get? identities user)
    found (ok found)
    err-not-found
  )
)