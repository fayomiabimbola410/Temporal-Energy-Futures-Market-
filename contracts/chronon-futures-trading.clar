;; Chronon Futures Trading Contract

(define-map futures
  { id: uint }
  {
    owner: principal,
    amount: uint,
    price: uint,
    expiration: uint
  }
)

(define-data-var next-future-id uint u0)

(define-public (create-future (amount uint) (price uint) (expiration uint))
  (let
    ((new-id (var-get next-future-id)))
    (var-set next-future-id (+ new-id u1))
    (ok (map-set futures
      { id: new-id }
      {
        owner: tx-sender,
        amount: amount,
        price: price,
        expiration: expiration
      }
    ))
  )
)

(define-public (buy-future (future-id uint))
  (match (map-get? futures { id: future-id })
    future
      (begin
        (asserts! (< block-height (get expiration future)) (err u400))
        (try! (stx-transfer? (get price future) tx-sender (get owner future)))
        (ok (map-set futures
          { id: future-id }
          (merge future { owner: tx-sender })
        )))
    (err u404)
  )
)

(define-read-only (get-future (id uint))
  (map-get? futures { id: id })
)

