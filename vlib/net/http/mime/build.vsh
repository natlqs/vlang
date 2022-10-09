import net.http
import json

struct MimeType {
	source       string
	extensions   []string
	compressible bool
	charset      string
}

fn main() {
	mt_json := http.get('https://raw.githubusercontent.com/jshttp/mime-db/master/db.json')?
	mt_map := json.decode(map[string]MimeType, mt_json.text)?

	mut ext_to_mt_str := map[string]string{}
	for mt_str, mt in mt_map {
		for ext in mt.extensions {
			ext_to_mt_str[ext] = mt_str
		}
	}

	write_file('db.v', '
	module mime

	// FILE AUTOGENERATED BY `build.vsh` - DO NOT MANUALLY EDIT

	const (
		db = $mt_map
		ext_to_mt_str = $ext_to_mt_str
	)
	')?
	execute('${@VEXE} fmt -w db.v')
}
