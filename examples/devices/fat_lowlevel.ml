open Lwt
open Printf

let main () =
  let finished_t, u = Lwt.task () in
  let listen_t = OS.Devices.listen (fun id ->
    OS.Devices.find_blkif id >>= function
      | None -> return ()
      | Some blkif -> Lwt.wakeup u blkif; return ()
  ) in
  printf "Acquiring a block device\n%!";
  (* Get one device *)
  lwt blkif = finished_t in
  (* Cancel the listening thread *)
  Lwt.cancel listen_t;
  printf "Block device ID: %s\n%!" blkif#id;
  printf "Connected block device\n%!";

  let open Fs.Fat in
  let module M = struct
	let read_sector = read_sector blkif
    let write_sector = write_sector blkif
  end in
  let module FS = FATFilesystem(M) in
  lwt fs = FS.make () in

  let handle_error f x =
    match_lwt x with
    | Error (Not_a_directory path) ->
      printf "Not a directory (%s).\n%!" (Path.to_string path);
	  return ()
    | Error (Is_a_directory path) ->
      printf "Is a directory (%s).\n%!" (Path.to_string path);
	  return ()
    | Error (Directory_not_empty path) ->
      printf "Directory isn't empty (%s).\n%!" (Path.to_string path);
	  return ()
    | Error (No_directory_entry (path, name)) ->
      printf "No directory %s in %s.\n%!" name (Path.to_string path);
	  return ()
    | Error (File_already_exists name) ->
      printf "File already exists (%s).\n%!" name;
	  return ()
    | Error No_space ->
      printf "Out of space.\n%!";
	  return ()
    | Success x -> f x in

  let do_list path =
    handle_error
      (function Stat.Dir(_, ds) ->
        printf "Directory for A:%s\n\n" (Path.to_string path);
        List.iter
          (fun x -> printf "%s\n" (Dir_entry.to_string x)) ds;
        printf "%9d files\n%!" (List.length ds);
		return ()
      ) (FS.stat fs path);
    return () in
  let do_create path data =
    handle_error
      (fun () -> return ())
      (FS.create fs path);
    handle_error
      (fun () -> return ())
      (FS.write fs (FS.file_of_path fs path) 0 data);
    return () in


  let path = Path.of_string "/" in

  lwt () = do_list path in
  lwt () = do_create (Path.of_string "/hello.txt") (Bitstring.bitstring_of_string "wassup?") in
  return ()
