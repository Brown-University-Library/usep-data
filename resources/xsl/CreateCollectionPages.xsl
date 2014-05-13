<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    <!--

    -->

    <xsl:output 
    	method="html"
        encoding="utf-8"
        name="myHTML"
        />
        
    <xsl:key name="collections" match="names/name" use="@collection"></xsl:key>
    
    <xsl:template match="/">
        <collections>
        <xsl:for-each select="//name[generate-id() = generate-id(key('collections',@collection)[1])]">
            <xsl:sort select="@collection" case-order="upper-first" />
            <xsl:variable name="filename" select="concat('../new_collections/',@collection,'.html')" />
				<xsl:value-of select="$filename" />  <!-- Creating  -->
				<xsl:result-document href="{$filename}" format="myHTML">

					<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US" xml:lang="en-US">
					<head>
					 	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
					
					 	<title>US Epigraphy: <xsl:value-of select="@collection" /></title>
					 	<link rel="stylesheet" type="text/css" href="../style.css" />
					</head>
					
					<body>
						<div id="header">
							<a href="../index.html"><img src="../gfx/header_brickstamp.png" alt="U.S. Epigraphy Project" title="U.S. Epigraphy Project home page"/></a>
					
							<div id="headerlinks">
								<a href="../search.html"><img src="../gfx/button_search.png"
							alt="search"/></a>
								<a href="../index.html"><img src="../gfx/button_collections.png"
							alt="collections" /></a>
								<a href="../publications.html"><img src="../gfx/button_publications.png"
							alt="publictaions" /></a>
							<br />
								<a href="../texts.html">Texts</a> |
								<a href="../links.html">Epigraphy links</a> |
								<a href="../about.html">About</a> |
								<a href="../contact.html">Contact</a>
							</div>
						</div>
					
					
						<h1 id="pagetitle">Inscriptions from <xsl:value-of select="@collection" /></h1>
					
						<div id="listofstates"></div>
					
						<div id="main">
							<div id="container">
								<ul class="collection">
									<xsl:variable name="collection-name" select="@collection" />
									<xsl:for-each select="//name[@collection=$collection-name]">
										<xsl:sort select="//name[@collection=$collection-name][1]" case-order="upper-first" />
										<li>
											<xsl:if test="string-length(./@Thumbnail) > 0">
												<img class="thumb" src="http://usepigraphy.brown.edu/Pictures/Thumbnails/CA.Berk.UC.HMA.G.8-4213.jpg" alt="Thumbnail indicating there is an image." width="40" height="40">
													<xsl:attribute name="src" select="concat('http://usepigraphy.brown.edu/Pictures/Thumbnails/',./@Thumbnail)" />
												</img>
											</xsl:if>
											<a>
												<xsl:attribute name="href" select="concat('../view/#',./@id)" />
												<xsl:value-of select="." />
												<xsl:if test="(./@Transcription='True')">
													<xsl:text> [transcription]</xsl:text>
												</xsl:if>
												<xsl:if test="(./@BibOnly='True')">
													<xsl:text> [bib only]</xsl:text>
												</xsl:if>
												<xsl:if test="(./@Metadata='True')">
													<xsl:text> [metadata]</xsl:text>
												</xsl:if>													
											</a>
										</li>
									</xsl:for-each>	
								</ul>		
							</div>
						</div>
					</body>
				</html>
            </xsl:result-document>
        </xsl:for-each>
        </collections>
    </xsl:template>
    
</xsl:stylesheet>
