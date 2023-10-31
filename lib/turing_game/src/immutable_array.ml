include Array

let of_array_mapi a ~f = init (Array.length a) ~f:(fun index -> f index a.(index))
