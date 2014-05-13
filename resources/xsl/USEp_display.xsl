<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd t"
    xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    version="2.0">
    
    <!-- ******************************************************************************
        Takes an inscription marked up in Epidoc (US Ep version, Winter 2011) and
        transforms it to HTML for display. This is based on the US Ep proofreading 
        XSL and on the original USEp display XSL.
        
        **Change Log
        2011-11-8 EM Begun
        2011-11-29 EM adding edition handling
        
        ******************************************************************************   -->
    <!-- Work plan:
          
    -->
    
    <!-- The included files below are imported from the epidoc html conversion. We
    want to use them for converting transcriptions. 
    -->
    
    <!-- ******************** Start Epidoc Includes ******************** -->


    <!-- ********************  End Epidoc Includes  ******************** -->
    
    
    <!-- ********************  This handles the bibliography  ******************** -->
            <!-- <xsl:include href="include_bibl.xsl"/> --> 
    
    <!-- ** line break in output file; improves human readability of xml output ** -->
    
     <xsl:output indent="yes" encoding="utf-8" />
    <xsl:variable name="imageDir" select="'../Pictures/images'"/>
    <xsl:variable name="thumbDir" select="'../Pictures/Thumbnails'"/>
    
     <xsl:include href="epidoc-xsl/start-edition.xsl"/>
    
    <!-- Output is not complete HTML file, because in our case, the view.js script that David wrote handles 
        everything including <body> and the title of the page. We make a div to enclose the output of the metadata
        the text, image(s) and bib. Each of those has its own div as well.
        If a whole HTML page has to be output, the HTML enclosing tags and the <head> element can be put into
        the first template below.
    -->
    <xsl:template match="/">
            <div>
                
                <!-- This outputs the full text description at the top of the page, after checking that there are descriptions to output. -->
                <div class="titleBlurb">
                    <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/*">   
                     <h3>Summary</h3>
                        <p><xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msContents/msItem/p"/>.<br />
                            <xsl:value-of select="normalize-space(/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/supportDesc/support/p)"/>.
                        </p>
                 </xsl:if>
                </div>
                
<!-- enclosing div so that metadata and images can be side by side -->
                <div class="topDivs">                
    <!-- This outputs the inscription metadata, after checking that there is some. -->
                    <xsl:if test="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/*">
                    <div class="metadata">
                        <h3>Attributes</h3>
                        
<table>
                            <tr><td class="label">Inscription Type</td><td class="value"><xsl:value-of select="id(substring-after(/TEI/teiHeader/fileDesc/sourceDesc/msDesc/msContents/msItem/@class, '#'))/catDesc"/></td></tr>
                            <tr><td class="label">Object Type</td><td class="value"><xsl:value-of select="id(substring-after(/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/@ana, '#'))/catDesc"/></td></tr>
                            <tr><td class="label">Material</td><td class="value"><xsl:value-of select="id(substring-after(/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objecpesc/supportDesc/@ana, '#'))/catDesc"/></td></tr>
                            <tr><td class="label">Provenance</td><td class="value"><xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/origin/placeName"/></td></tr>
                            <tr><td class="label">Date</td><td class="value"><xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/history/origin/date"/></td></tr>
                            <!-- check for existence of controlled and full text values here. -->
                            <tr><td class="label">Layout</td><td class="value"><xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/layoutDesc/layout/@columns"/> columns, <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/layoutDesc/layout/@writtenLines"/> lines</td></tr>
                            <tr><td class="label">Writing</td><td class="value"><xsl:value-of select="id(substring-after(/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/handDesc/@ana, '#'))/catDesc"/> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/handDesc/handNote"/></td></tr>
                            <tr><td class="label">Condition</td><td class="value"><xsl:value-of select="id(substring-after(/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/supportDesc/condition/@ana, '#'))/catDesc"/> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/objectDesc/supportDesc/condition/p"/></td></tr>
                            <tr><td class="label inactive">Decoration</td><td class="value"><xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/decoDesc/@ana"/> <xsl:value-of select="/TEI/teiHeader/fileDesc/sourceDesc/msDesc/physDesc/handDesc/decoNote"/></td></tr>
                        </table>
                        </div> 
                </xsl:if>  
                
                <!-- Output the images (hope to format these at upper  right perhaps?), again, first checking to see if there are any. -->
                
                    <div class="facsimile">
                        <xsl:if test="/TEI/facsimile">
                        
                            <h3>Images</h3>
                        <div id="image_wrap">
                            
                            <!-- Initially the image is a simple 1x1 pixel transparent GIF -->
                            <img src="http://static.flowplayer.org/tools/img/blank.gif"/>
                            
                        </div>
                        
                            <div class="items">
                                <xsl:for-each select="/TEI/facsimile/surface">
                                    <xsl:for-each select="graphic">
                                       <img src="{concat($thumbDir, '/',@url)}"/>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </div>
                            
                        </xsl:if> 
                 </div>
                </div>    
                
                <!-- This outputs the text using Epidoc stylesheets, checks to see if there is a transcription. -->
  				<xsl:if test="/TEI/text/body/div[@type='edition']/ab">
                 	<xsl:apply-templates select="/TEI/text/body/div[@type='edition']"/> 
                 </xsl:if>
                
      <!-- This outputs the bibliography. No need to check, there is always bibliography. -->
                <div class="bibl">
                    <h3>Bibliography</h3>
                    <xsl:call-template name="bibl"/>

                        <!-- this should be enclosed in a bibl and put into the bibliography script,
                            it should also check that link is descendant of div type=bib -->
                  
                </div>
                                        <p><a href="{concat('http://dev.stg.brown.edu/projects/usepigraphy/new/xml/',/TEI/teiHeader/fileDesc/publicationStmt/idno/@xml:id,'.xml')}">View XML source file</a></p>

            </div>
    </xsl:template>
       
    <!-- ****************** This outputs the bibliography ******************** -->
    
    <xsl:template name="bibl">
       
        <xsl:for-each select="/TEI/teiHeader/fileDesc/sourceDesc/listBibl/bibl">
            <xsl:variable name="myID" select="substring-after(ptr/@target, '#')"/>
          <!--   <xsl:value-of select="$myID"/> -->
            <p>
                <!-- Note: I'm not handling cases where articles are directly in the monograph. Only where they
                    are in a volume. We don't have any, so let's do it later.
                    
                    We also have to check for itemAuthors and notes. 
                    2005.10.18 EM broke bibl out into separate file, to include
                    fixed output so unpublished inscriptions format correctly.
                -->
                <!-- Output the author, if there is one. Right now, assumption is that there is an 
                    potentially an author on the bibl if it's an article, or on the outermost bibl if
                    it's a corpus or monograph.
                -->
                
                <xsl:choose>
                    <xsl:when test="id($myID)/author/persName[@type='sort']">
                        <xsl:value-of select="concat(id($myID)/author/persName[@type='sort'], ', ')"/>
                    </xsl:when>
                    <xsl:when test="id($myID)/author/persName">
                        <xsl:value-of select="concat(id($myID)/author/persName, ', ')"/>
                    </xsl:when>
                </xsl:choose>
                
                <!-- output title or abbreviation. if it's a monograph, output the title. If  corpus or a journal
                    output the abbreviation if there is one. I am not outputting titles for volumes or articles, as
                    we don't have any. If it's an abbreviation, link it back to the bibliography. This was changed. Code
                    left in. 
                -->
                
                <xsl:choose>
                    <xsl:when test="id($myID)/ancestor-or-self::bibl[@type='m' or @type='u']/title">
                        <i>
                            <xsl:value-of select="id($myID)/ancestor-or-self::bibl[@type='m' or @type='u']/title"/>
                        </i>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="id($myID)/ancestor-or-self::bibl[@type='c' or @type='j']/abbr">
                                <!-- I  have commented out the code that made an abbreviation into a link to the actual bibliographic entry -->
                                <!-- <a href="../refList.html#{//bibl[@id=$myID]/ancestor-or-self::bibl[@type='c' or @type='j']/@id}"> -->
                                <i>
                                    <xsl:value-of select="id($myID)/ancestor-or-self::bibl[@type='c' or @type='j']/abbr[@type='primary']"/>
                                </i>
                                <!-- </a> -->
                            </xsl:when>
                            <xsl:otherwise><xsl:value-of select="id($myID)/ancestor-or-self::bibl[@type='c' or @type='j']/title"/></xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
                
                <!-- output the volume, if there is one. with a space before it. -->
                
                <xsl:if test="id($myID)/ancestor-or-self::bibl[@type='v']">
                    <xsl:value-of select="concat(' ', id($myID)/ancestor-or-self::bibl[@type='v']/biblScope)"/>
                </xsl:if>
                
                <!-- output the year, if there is one. with a space before it and inside parentheses. -->
                
                <xsl:choose>
                    <xsl:when test="id($myID)/date">
                        <xsl:value-of select="concat(' (',id($myID)/date, ')')"/>
                    </xsl:when>
                    <xsl:when test="id($myID)/ancestor-or-self::bibl[@type='v' or type='m']/date">
                        <xsl:value-of select="concat(' (',id($myID)/ancestor-or-self::bibl[@type='v' or type='m']/date, ')')"/>
                    </xsl:when>
                </xsl:choose>
                
                <!-- everything has a reference except for unpub. but put a space before it. -->
                
                <xsl:if test="biblScope">
                    <xsl:value-of select="concat(': ', biblScope)"/>
                </xsl:if>
                
                <xsl:if test="itemAuthor">
                    <xsl:value-of select="concat(' [', itemAuthor, ']')"/>
                </xsl:if>   
                
                <!-- This prints the jstor link   -->
                <xsl:if test="id($myID)/link">
                    <br />
                    (<a href="{id($myID)/link/a/@href}" class="biblink"><xsl:value-of select="id($myID)/link/a"/></a> (external link; access to JSTOR required))
                </xsl:if>
                
              <!--
                  <xsl:element name="br"/> original code, remove if new code above works.
                  <xsl:text>[</xsl:text>
                  <xsl:element name="a">
                        <xsl:attribute name="href">
                            <xsl:value-of select="id($myID)/link/a/@href"/>
                        </xsl:attribute>
                        <xsl:attribute name="class">bibLink</xsl:attribute>             
                        <xsl:value-of select="id($myID)/link/a"/>              
                    </xsl:element>
                    <xsl:text> (external link; access to JSTOR required)]</xsl:text> -->
 
                <!-- There may be a <bibl> with an external link inside, for example, to EDH. -->
                
                <xsl:if test="ref">
                    <a href="{ref/@target}"><xsl:value-of select="ref"/></a> (external link)
                </xsl:if>
                
            </p>
        </xsl:for-each>
    </xsl:template>
   
    
</xsl:stylesheet>
