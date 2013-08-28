csv
===

A basic type for reading, writing, and serving CSV files. Based on previous Lasso 8 version from Jason Huck

Properties
==========

->fields - An array containing the column names for the CSV file. Will default to [field_names] on creation if/when possible.

->rows - An array of arrays containing the data for the CSV file. Will default to [rows_array] on creation if/when possible.

->loadpath - String, the path to a CSV file to parse into the type.

->titlerow - Boolean, whether or not the CSV file contains a title row. Pertains to both loading and saving files. Defaults to false.

->savepath - String, where to save the CSV file.

->filename - String, the name to use when saving the file. Defaults to "results.csv."


Member Tags/Methods
===================

->parseline - Parses an individual line of a loaded file. Used internally by ->load.

->load - Loads a CSV file from the given path. Optionally accepts a boolean 'titlerow' parameter indicating whether or not the source file contains a title row.

->output - Returns the contents of the object formatted as a CSV file. Used internally by ->save and ->serve.

->save - Saves a CSV file to the given path.

->serve - Serves a CSV file to the browser using the csv mime type and filename supplied.

->addrow - Accepts an array to add to ->rows.
