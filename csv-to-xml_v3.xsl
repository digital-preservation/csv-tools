<?xml version="1.0" encoding="UTF-8"?>
<!--
	This is a modified work from The National Archives
	based on an original work by Andrew Welch.
	This could be considered version 3 of Andrew's work

	Andrews Original Intro
	======================

	A CSV to XML transform
	Version 2
	Andrew Welch
	http://andrewjwelch.com
	
	Modify or supply the $pathToCSV parameter and run the transform
	using "main" as the initial template.
	
	For bug reports or modification requests contact me at andrew.j.welch@gmail.com

	
	Modification by the National Archives
	=====================================

	** Modified so output is UTF-8 declared. Adam Retter 2011-11-17
	** Modified to terminate processing if the input file cannot be found. Adam Retter 2011-11-17 
	** Modified so that pathToCSV parameter is mandatory. Adam Retter 2011-12-08
	** Modified to work on CSV files that have either Unix (LF) or Windows (CRLF) line endings. Adam Retter 2011-12-08
	** Modified to skip empty row in-case of trailing line ending. Adam Retter 2011-12-08
-->
  		
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="fn"
	exclude-result-prefixes="xs fn">

	<xsl:output method="xml" omit-xml-declaration="no" byte-order-mark="no" media-type="application/xml" version="1.0" indent="yes" encoding="UTF-8"/>
	
	<!-- e.g. file:///c:/csv.csv -->
	<xsl:param name="pathToCSV" as="xs:string"/>
	
	<xsl:function name="fn:getTokens" as="xs:string+">
		<xsl:param name="str" as="xs:string"/>
			<xsl:analyze-string select="concat($str, ',')" regex='(("[^"]*")+|[^,]*),'>
				<xsl:matching-substring>
					<xsl:sequence select='replace(regex-group(1), "^""|""$|("")""", "$1")'/>
				</xsl:matching-substring>
			</xsl:analyze-string>
	</xsl:function>
	
	<xsl:template match="/" name="main">
		<xsl:choose>
			<xsl:when test="unparsed-text-available($pathToCSV)">
				<xsl:variable name="csv" select="unparsed-text($pathToCSV)"/>
				<xsl:variable name="lines" select="tokenize($csv, '(&#xa;)|(&#xd;&#xa;)')" as="xs:string+"/>
				<xsl:variable name="elemNames" select="fn:getTokens($lines[1])" as="xs:string+"/>
				<root>
					<xsl:for-each select="$lines[position() > 1][. != '']">
						<row>
							<xsl:variable name="lineItems" select="fn:getTokens(.)" as="xs:string+"/>
	
							<xsl:for-each select="$elemNames">
								<xsl:variable name="pos" select="position()"/>
								<elem name="{.}">
									<xsl:value-of select="$lineItems[$pos]"/>
								</elem>
							</xsl:for-each>
						</row>
					</xsl:for-each>
				</root>
			</xsl:when>
			<xsl:otherwise>
				<xsl:message terminate="yes">
					<xsl:text>Cannot locate : </xsl:text><xsl:value-of select="$pathToCSV"/>
				</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
