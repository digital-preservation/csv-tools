csv-tools
=========

Tools for working with CSV files.

At the moment just csv2xslt.xml which is an XSLT 2.0 Stylesheet for transforming CSV files to XML.

How to use
==========
You need to supply the $pathToCSV parameter to the transformation to
instruct it on where to find your CSV file when you run the transform.
To run the Transform you must set 'main' as the initial template.


Example using Saxon:

java -jar saxonhe-9.3.0.4-j.jar pathToCSV=/tmp/a.csv -xsl:csv-to-xml_v3.xsl -it:main -o:a.xml

The above transforms the file /tmp/a.csv to the file /tmp/a.xml
