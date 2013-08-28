define csv => type {
	/*
	csv
	A basic type for reading, writing, and serving CSV files.
	https://github.com/iamjono/csv
	
	A basic type for reading, writing, and serving CSV files.
	adapted and partially rewritten from Jason Hucks work 
	http://www.lassosoft.com/tagswap/detail/csv
	
	*/
	data
		public fields 		= array,
		public rows 		= array,
		public loadpath 	= string,
		public titlerow 	= false,
		public savepath 	= string,
		public filename 	= 'results.csv'
	
	public auto() => {
			field_names->size ? .fields = field_names
			rows_array->size ? .rows = rows_array		
	}
    public parseline(line::string) => {
		local(
			field 	= string, 
			i 		= null, 
			row 	= array
		)
         
		iterate(
			string_findregexp(
			#line, 
			-find = '"(?:[^"]|"")*"|[^,]*|,'
			), 
			#i
		) => {
			if(#i == ',') => {
				#row->insertlast(#field)
				#field = string
		     
			else(#i->beginswith('"') && #i->endswith('"'))
				#field->append(#i->substring(2, #i->size - 2)->replace('""', '"')&)
		     
			else
				#field->append(#i) 
			}
		}
		#row->insertlast(#field)
		return #row
	}

	
	public load() => {
		fail_if(not .loadpath->size,0,'Please supply a valid file path')
		fail_if( (!file_exists(.loadpath) || !file_read(.loadpath)),error_code,error_msg)
      
		local(in = file_read(.loadpath), counter = 0)
		with line in #in->split('\r\n') do => {
			#counter += 1	
			.titlerow && #counter == 1 
				? .fields = .parseline(#line)
				| .rows->insert(.parseline(#line))
		}
	}
	public output() => {
		local(out = string)
		.titlerow && .fields->size ? #out->append('"'+.fields->join('","')+'"\r\n')
		with r in .rows do => {
			local(ff = array)
			if(#r->isA(::map)) => {
				with fld in .fields do => {
					// filtering for line breaks and double quotes
					local(f = #r->find(#fld)->asString)
					#f->replace('"','""')&replace('\r\n','\n')&replace('\r','\n')
					#ff->insert(#f)
				}
			else // array
				with f in #r do => {
					// filtering for line breaks and double quotes
					#f->replace('"','""')&replace('\r\n','\n')&replace('\r','\n')
					#ff->insert(#f)
				}
			}
			#out->append('"'+#ff->join('","')+'"\r\n')
		}
		#out->removetrailing('\r\n')
		return #out
	}
	public save() => {
		local(f = file(.savepath))
		handle => { #f->close }
		#f->writeBytes(.output->asBytes)
	}
	public serve() => { web_response->sendFile(.output, .filename, -type='text/csv') }
	public addRow(-data::array) => { .rows->insert(#data) }
	public addRow(data::array) => { .rows->insert(#data) }
}