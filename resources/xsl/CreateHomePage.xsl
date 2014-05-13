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

		<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US" xml:lang="en-US">  
			<head>    
				<meta http-equiv="content-type" content="text/html; charset=utf-8" ></meta>
				<title>U.S. Epigraphy Home</title>
				<link type="text/css" href="../style.css" media="all" rel="stylesheet" />
				<script type="text/javascript" src="http://code.jquery.com/jquery-1.4.3.min.js"></script>
				<script type="text/javascript">
					function showInfo () {
					  var el = $(this);
					  el.parent().next('.js-info').toggle('fast', 'swing');
					  return false;
					}
				
					$(document).ready(function() {
					  if (window.location.hash !== '#showall') {
						$('.js-info').hide();
					  }
					  $('.js-link').click(showInfo);
					  
					  $('#showall').click(function(event) {
						$('.js-info').show();
					  });
					});
				</script>
  
			</head>
			<body>
				
				<div id="header">
					<a href="index.html"><img src="../gfx/header_brickstamp.png" alt="U.S. Epigraphy Project" title="U.S. Epigraphy Project home page"/></a>
				
					<div id="headerlinks">
						<a href="search.html"><img src="../gfx/button_search.png" /></a>
						<a href="index.html"><img src="../gfx/button_collections.png" /></a>
						<a href="publications.html"><img src="../gfx/button_publications.png" /></a> <br />
							<a href="texts.html">Texts</a> | 
							<a href="links.html">Epigraphy links</a> | 
							<a href="about.html">About</a> | 
							<a href="contact.html">Contact</a>
					</div>
				</div>
				
					<h1 id="pagetitle">List of U.S. Collections</h1>
				
				<div id="listofstates">
				<ul id="list">
					<li>| <a href="#ca">CA</a></li>
					<li><a href="#ct">CT</a></li>
					<li><a href="#dc">DC</a></li>
					<li><a href="#fl">FL</a></li>
					<li><a href="#ga">GA</a></li>
					<li><a href="#hi">HI</a></li>
					<li><a href="#ia">IA</a></li>
					<li><a href="#il">IL</a></li>
					<li><a href="#in">IN</a></li>
					<li><a href="#ks">KS</a></li>
					<li><a href="#ky">KY</a></li>
					<li><a href="#ma">MA</a></li>
					<li><a href="#md">MD</a></li>
					<li><a href="#me">ME</a></li>
					<li><a href="#mi">MI</a></li>
					<li><a href="#mn">MN</a></li>
					<li><a href="#mo">MO</a></li>
					<li><a href="#ms">MS</a></li>
					<li><a href="#nc">NC</a></li>
					<li><a href="#nh">NH</a></li>
					<li><a href="#nj">NJ</a></li>
					<li><a href="#ny">NY</a></li>
					<li><a href="#oh">OH</a></li>
					<li><a href="#ok">OK</a></li>
					<li><a href="#pa">PA</a></li>
					<li><a href="#ri">RI</a></li>
					<li><a href="#tx">TX</a></li>
					<li><a href="#va">VA</a></li>
					<li><a href="#wa">WA</a></li>
				</ul>
				</div>	
				
				<div id="content"> 
					<xsl:for-each select="//name[generate-id() = generate-id(key('collections',@collection)[1])]">
						<xsl:sort select="@collection" case-order="upper-first" />									
						<p class="description">
							<a>
								<xsl:attribute name="href" select="concat(@collection,'.html')" />
								<xsl:value-of select="@collection" />
							</a>
						</p>
					</xsl:for-each>
				</div>
			</body>
		</html>
    </xsl:template>
    
</xsl:stylesheet>
