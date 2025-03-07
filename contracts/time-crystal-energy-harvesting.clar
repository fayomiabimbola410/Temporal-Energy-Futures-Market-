;; Time Crystal Energy Harvesting Contract

(define-map harvesters
  { id: uint }
  {
    owner: principal,
    energy: uint,
    last-harvest: uint
  }
)

(define-data-var next-harvester-id uint u0)

(define-public (register-harvester)
  (let
    ((new-id (var-get next-harvester-id)))
    (var-set next-harvester-id (+ new-id u1))
    (ok (map-set harvesters
      { id: new-id }
      {
        owner: tx-sender,
        energy: u0,
        last-harvest: block-height
      }
    ))
  )
)

(define-public (harvest-energy (harvester-id uint))
  (match (map-get? harvesters { id: harvester-id })
    harvester
      (let
        ((energy-gained (- block-height (get last-harvest harvester))))
        (ok (map-set harvesters
          { id: harvester-id }
          {
            owner: (get owner harvester),
            energy: (+ (get energy harvester) energy-gained),
            last-harvest: block-height
          }
        )))
    (err u404)
  )
)

(define-read-only (get-harvester (id uint))
  (map-get? harvesters { id: id })
)

