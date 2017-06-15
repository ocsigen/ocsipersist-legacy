let file = ref (Ocsigen_config.get_datadir () ^ "/ocsidb")

let get_file () = !file

let set_file = (:=) file
