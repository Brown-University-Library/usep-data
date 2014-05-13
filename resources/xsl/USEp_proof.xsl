<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      exclude-result-prefixes="xs"
      xmlns:usepi="http://www.tei-c.org/ns/1.0"
      version="2.0">
    
<!-- line break in output file; improves human readability of xml output -->
<xsl:variable name="newline"><xsl:text>
</xsl:text></xsl:variable>
    
    <xsl:output method="html" 
        indent="yes" 
        encoding="utf-8" />
        
         <xsl:include href="epidoc-xsl/start-edition.xsl"/>    

    <xsl:template match="/">     
        <html>
            <head><xsl:text disable-output-escaping="yes">&lt;/meta&gt;</xsl:text><title>USEpigraphy Transcription Summary</title>
             	<link rel="stylesheet" type="text/css" href="http://dev.stg.brown.edu/projects/usepigraphy/new/global.css" />
	<link rel="stylesheet" type="text/css" href="http://dev.stg.brown.edu/projects/usepigraphy/new/global-parameters.css" />
</head>
            <body>
                <xsl:apply-templates/>
                     <xsl:apply-templates select="/TEI/text/body/div[@type='edition']"/>

            </body>
        </html>
    </xsl:template>
   
   <xsl:template match="usepi:teiHeader">
   
   <h2>Proofreading Output for <xsl:value-of select="usepi:fileDesc/usepi:titleStmt/usepi:title"/></h2>
   
   <p>This page will show you the values you have encoded for inscription metadata and transcription, in a format that makes proofreading easier. Please make sure that your file is valid before proofreading. The proofreading script does not check for validity. Also, note that all items in the list below that are preceded by an asterisk (*) are <i>required</i>. If nothing shows up in the proofreading page, you should go back and check your xml file, and either add missing information or, if the information is there, make sure that it is encoded correctly. 
   </p>

      <hr />
       
        <p>
           <b>*Title: </b> <xsl:value-of select="usepi:fileDesc/usepi:titleStmt/usepi:title"/>
               <br />
           <b>*Machine-Readable (safe) Title: </b><xsl:value-of select="usepi:fileDesc/usepi:publicationStmt/usepi:idno/@xml:id"/>
        </p>     
       <hr />
       
        <p>
            <b><i>Source Description</i></b>
               <br />
            <b>*Region: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:msIdentifier/usepi:region" />
               <br />
            <b>*Settlement: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:msIdentifier/usepi:settlement" />
               <br />
            <b>*Institution: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:msIdentifier/usepi:institution" />
               <br />
            <b>Repository: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:msIdentifier/usepi:repository" />
               <br />
            <b>*idno: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:msIdentifier/usepi:idno" />
        </p>
       
      <hr />
       
       <p>
           <b><i>Contents</i></b> (&lt;msItem&gt;):
               <br />
           <b>*Class: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:msContents/usepi:msItem/@class" />
               <br />
           <b>*Short Description: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:msContents/usepi:msItem/usepi:p" />
       </p> 
       
      <hr />
       
       <p>
           <b><i>Physical Description</i></b>
               <br />
           <b>*ObjectDesc</b> (@ana): <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/@ana" />
               <br />
               <br />
           <b>*SupportDesc</b>  (@ana): <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/usepi:supportDesc/@ana" />
               <br />
           <b>*Support gloss: </b> <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/usepi:supportDesc/usepi:support/usepi:p" />
               <br />
               <br />
           <b>*Dimensions: </b> 
           Height - <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/usepi:supportDesc/usepi:support/usepi:dimensions/usepi:height" /> / 
           Width - <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/usepi:supportDesc/usepi:support/usepi:dimensions/usepi:width" /> / 
           Depth - <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/usepi:supportDesc/usepi:support/usepi:dimensions/usepi:depth" />
               <br />
               <br />
           <b>*Condition</b> (@ana): <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/usepi:supportDesc/usepi:condition/@ana" />
           <br />
           <b>Condition gloss:</b> <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/usepi:supportDesc/usepi:condition/usepi:p" />
       </p>  
       
      <hr />       
       
       <p>
           <b><i>Layout Description</i></b> (Columns and Written Lines not required if not applicable. In that case, add a gloss in the &lt;p&gt;)
               <br />
           <b>*Columns: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/usepi:layoutDesc/usepi:layout/@columns" />
               <br />
           <b>*Written Lines: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/usepi:layoutDesc/usepi:layout/@writtenLines" />
               <br />
           <b>layoutDesc Gloss </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:objectDesc/usepi:layoutDesc/usepi:layout/usepi:p" />
       </p>  
       
      <hr />     
       
       <p>
           <b><i>Hand Description</i></b>
               <br />
           <b>*HandNote @ana: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:handDesc/usepi:handNote/@ana" />
               <br />
           <b>HandNote Gloss: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:handDesc/usepi:handNote/usepi:p" />
       </p>       
       
      <hr />     
       
       <p>
           <b><i>Deco Description</i></b>
               <br />
           <b>DecoNote @ana: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:decoDesc/usepi:decoNote/@ana" />
               <br />
           <b>*DecoNote Gloss: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:physDesc/usepi:decoDesc/usepi:decoNote/usepi:p" />           
       </p>      
       
      <hr />     
       
       <p>
           <b><i>History</i></b>
               <br />
           <b>Summary: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:summary/usepi:note" />
               <br />
               <br />
           <b><i>Origin: </i></b>
               <br />
           <b>*Date: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:origin/usepi:date" /> [<b>NotBefore </b> <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:origin/usepi:date/@notBefore" /> - <b>NotAfter </b> <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:origin/usepi:date/@notAfter" />]
               <br />    
           <b>*PlaceName: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:origin/usepi:placeName/text()" /> [<b>ref: </b> <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:origin/usepi:placeName/@ref" />]             
               <br />
               <br />
           <b><i>Provenance: </i></b>
               <br />
           <b>Date: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:provenance/usepi:date" /> [<b>NotBefore </b> <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:provenance/usepi:date/@notBefore" /> - <b>NotAfter </b> <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:provenance/usepi:date/@notAfter" />]
               <br />            
           <b>PlaceName: </b><xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:provenance/usepi:placeName/text()" /> [<b>ref: </b> <xsl:value-of select="usepi:fileDesc/usepi:sourceDesc/usepi:msDesc/usepi:history/usepi:provenance/usepi:placeName/@ref" />]
       </p>   
       
      <hr />     
       
       <p>
           <b><i>*Bibliography</i></b>
           
           <xsl:for-each select="usepi:fileDesc/usepi:sourceDesc/usepi:listBibl/usepi:bibl">
           <br /><br />
           <b>xml:id of work cited: </b><xsl:value-of select="usepi:ptr/@target" />
               <br />
           <b>pages for citation: </b><xsl:value-of select="usepi:biblScope/text()" />
           </xsl:for-each>               
       </p>      
       
      <hr />     
       
       <p>
           <b><i>*Revision Description</i></b>
               <br />
               <xsl:for-each select="usepi:revisionDesc/usepi:change">
           <b>Who: </b><xsl:value-of select="@who" />; 
           <b>When: </b><xsl:value-of select="@when" />; 
           <b>Change: </b><xsl:value-of select="text()" />
           </xsl:for-each>
       </p>         
       
      <hr />         
       
   </xsl:template>
    
    <xsl:template match="usepi:facsimile">
        
        <p>
            <b><i>Facsimile</i></b>
            
            <xsl:for-each select="usepi:graphic">
                    <br />    
                <b>Graphic URL: </b><xsl:value-of select="@url" />
            </xsl:for-each> 
            
            
            <xsl:for-each select="usepi:surface">
                    <br />
                    <br />
                <b><i>Surface: </i></b>
                    <br />
                <b>Desc: </b><xsl:value-of select="usepi:desc/text()" /> 
                    <br />    
                <b>Graphic URL: </b><xsl:value-of select="usepi:graphic/@url" />             
            </xsl:for-each> 
        </p>  
        
       <hr />               
        
    </xsl:template>
    
<!-- 
    <xsl:template match="/usepi:TEI/usepi:text/usepi:body/usepi:div">
        <p>               
            
        <xsl:choose>        
        <xsl:when test="@type = 'apparatus'">
            <br />
            <br />
            <b>Apparatus: </b> <xsl:value-of select="usepi:p"/>
            <br />
            <br />            
        </xsl:when>
        <xsl:otherwise>
            <br />
            <b>Transcripion </b>
            <br />
            <br />            
            <xsl:apply-templates/>
        </xsl:otherwise>            
        </xsl:choose> 
            
        </p>        
    </xsl:template>
    
    <xsl:template match="//usepi:del">
        <xsl:text>[[</xsl:text>
        <xsl:apply-templates/> 
        <xsl:text>]]</xsl:text>
    </xsl:template>
      
    <xsl:template match="//usepi:add">
        <xsl:choose>
            <xsl:when test="@place = 'overstrike'">
                <xsl:text>&lt;&lt;</xsl:text>
                <xsl:apply-templates/>
                <xsl:text>&gt;&gt;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&apos;</xsl:text>
                <xsl:apply-templates/> 
                <xsl:text>&apos;</xsl:text>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="//usepi:lb">
        <xsl:if test="@type = 'worddiv'">
            <xsl:text>=</xsl:text>
            <xsl:value-of select="$newline"/>
            <xsl:value-of select="$newline"/>
        </xsl:if>
        <xsl:if test="@rend = 'right-to-left'">
            <xsl:text disable-output-escaping="yes">&#x2190;</xsl:text>            
        </xsl:if>
        <br />
    </xsl:template>
       
    <xsl:template match="//usepi:g">
        <xsl:choose>
            <xsl:when test="name(..) = 'am'">
                <xsl:value-of select="@type"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>((</xsl:text>
                <xsl:value-of select="@type"/>
                <xsl:text>))</xsl:text>              
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template match="//usepi:sic">
        <xsl:if test="name(..) != 'choice'">
                <xsl:text>{</xsl:text>
                <xsl:apply-templates/> 
                <xsl:text>}</xsl:text> 
        </xsl:if>     
    </xsl:template>
    
    <xsl:template match="//usepi:corr">
        <xsl:text disable-output-escaping="yes">&#8988;</xsl:text>
        <xsl:apply-templates/> 
        <xsl:text disable-output-escaping="yes">&#x231D;</xsl:text>      
    </xsl:template>
    
    <xsl:template match="//usepi:name">
        <xsl:choose>
            <xsl:when test="string-length(@type) != 0">
                <xsl:apply-templates/> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:text disable-output-escaping="yes">[-]</xsl:text>
            </xsl:otherwise>    
        </xsl:choose>            
        
    </xsl:template>
    
    <xsl:template name="gap" match="//usepi:gap">
		<xsl:param name="count" select="number(@extent)"/> 
        <xsl:choose>
        	<xsl:when test="@reason = 'illegible'">       
        		<xsl:if test="$count > 0">
	            	<xsl:text>+</xsl:text>
            		<xsl:call-template name="gap">
                		<xsl:with-param name="count" select="$count - 1"/>
            		</xsl:call-template>
        		</xsl:if>    
        	</xsl:when>
            <xsl:when test="@reason = 'ellipsis'">       
                <xsl:text>...</xsl:text>   
            </xsl:when>
            <xsl:when test="@reason = 'omitted'">       
                <xsl:text>(- - -)</xsl:text>   
            </xsl:when>
            <xsl:when test="@reason = 'lost'">       
                <xsl:if test="@unit = 'character' or @unit = 'chars' or @unit = 'char'">
                    <xsl:if test="$count = number(@extent) and (substring(@id,0,4) = 'gap' or substring(@xml:id,0,4) = 'gap')">
                        <xsl:text>[</xsl:text>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="substring(@id,0,4) = 'gap' or substring(@xml:id,0,4) = 'gap'">
                            <xsl:choose>
                                <xsl:when test="@extent = 'unknown'">
                                    <xsl:text>[- - -]</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="$count > 0">
                                        <xsl:text>-</xsl:text>
                                        <xsl:call-template name="gap">
                                            <xsl:with-param name="count" select="$count - 1"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>[-c.</xsl:text><xsl:value-of select="$count"/><xsl:text>-]</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>  
                    <xsl:if test="$count &lt;= 0">
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                </xsl:if> 
                <xsl:if test="@unit = 'line'">
                    <xsl:if test="@extent != 'unknown'">
                        <xsl:text>[</xsl:text>
                    </xsl:if>
                    <xsl:text>- - - - - </xsl:text> 
                    <xsl:if test="substring(@id,0,4) = 'gap' or substring(@xml:id,0,4) = 'gap'">
                        <xsl:text>?</xsl:text>
                    </xsl:if>
                    <xsl:if test="substring(@id,0,4) != 'gap' and substring(@xml:id,0,4) != 'gap'">
                        <xsl:text>-</xsl:text>
                    </xsl:if>
                    <xsl:if test="@extent != 'unknown'">
                        <xsl:text>]</xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:when>
        </xsl:choose>  
    </xsl:template>
    
    <xsl:template match="//usepi:abbr">
        <xsl:choose>
            <xsl:when test="name(..) != 'expan'">
                <xsl:apply-templates/> 
                <xsl:text>(- - -)</xsl:text> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/> 
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="//usepi:ex">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/> 
        <xsl:text>)</xsl:text>
    </xsl:template>
    
    <xsl:template match="//usepi:supplied">
        <xsl:choose>
            <xsl:when test="@reason = 'omitted'">
                <xsl:text>&lt;</xsl:text>
                <xsl:apply-templates/> 
                <xsl:text>&gt;</xsl:text>
            </xsl:when>
            <xsl:when test="@reason = 'lost'">
                <xsl:text>[</xsl:text>
                <xsl:apply-templates/> 
                <xsl:text>]</xsl:text>
            </xsl:when>  
            <xsl:when test="@reason = 'subaudible'">
                <xsl:text>(scil. </xsl:text>
                <xsl:text disable-output-escaping="yes">&lt;span style="font-style:italic"&gt;</xsl:text>
                <xsl:apply-templates/> 
                <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
                <xsl:text>)</xsl:text>
            </xsl:when>            
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="//usepi:note">
        <xsl:text>(</xsl:text>
        <xsl:apply-templates/> 
        <xsl:text>)</xsl:text>        
    </xsl:template>
    
    <xsl:template match="//usepi:space">
        <xsl:choose>
            <xsl:when test="@extent = 'unknown'">
                <xsl:text>(vac.?)</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>(vac.</xsl:text>
                <xsl:value-of select="@extent"/>                    
                <xsl:text>)</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="unclear" match="//usepi:unclear">
        <xsl:param name="count" select="0"/>
        <xsl:if test="$count &lt; number(string-length(.))">
            <xsl:value-of select="substring(.,$count+1,1)"/>
            <xsl:text>&#x0323;</xsl:text>
            <xsl:call-template name="unclear">
                <xsl:with-param name="count" select="$count + 1"/>
            </xsl:call-template>
        </xsl:if> 
    </xsl:template>
    
    <xsl:template name="hi" match="//usepi:hi">        
        <xsl:param name="count" select="0"/>
        <span style="font:13pt">        
        <xsl:if test="substring(normalize-space(.),$count+1,1) != ' ' and normalize-space(substring(normalize-space(.),$count+1,1)) != ''">
        <xsl:if test="child::node()/@rend = 'tall' or child::node()/@rend = 'longa'">
            <xsl:attribute name="style">
                <xsl:text disable-output-escaping="yes">font:14pt bold;</xsl:text>
            </xsl:attribute> 
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@rend = 'supraline'">
                <xsl:if test="$count &lt; number(string-length(normalize-space(.)))"> 
                    <xsl:choose>                    
                        <xsl:when test="child::node()/@rend = 'tall' or child::node()/@rend = 'longa'">
                            <xsl:value-of select="upper-case(substring(normalize-space(.),$count+1,1))"/>
                            <xsl:text>&#x0305;</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(normalize-space(.),$count+1,1)"/>
                            <xsl:text>&#x0305;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if> 
            </xsl:when>
            <xsl:when test="@rend = 'ligature'">
                <xsl:if test="$count &lt; number(string-length(normalize-space(.)))">
                    <xsl:choose>                    
                        <xsl:when test="child::node()/@rend = 'tall' or child::node()/@rend = 'longa'">
                            <xsl:value-of select="upper-case(substring(normalize-space(.),$count+1,1))"/>
                            <xsl:if test="($count mod 2) = 0">
                                <xsl:text>&#x0361;</xsl:text>
                            </xsl:if> 
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(normalize-space(.),$count+1,1)"/>
                            <xsl:if test="($count mod 2) = 0">
                                <xsl:text>&#x0361;</xsl:text>
                            </xsl:if> 
                        </xsl:otherwise>
                    </xsl:choose>                 
                </xsl:if> 
            </xsl:when>  
            <xsl:when test="@rend = 'apex'">
                <xsl:if test="$count &lt; number(string-length(normalize-space(.)))">
                    <xsl:choose>                    
                        <xsl:when test="child::node()/@rend = 'tall' or child::node()/@rend = 'longa'">
                            <xsl:value-of select="upper-case(substring(normalize-space(.),$count+1,1))"/>
                            <xsl:text>&#x0301;</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="substring(normalize-space(.),$count+1,1)"/>
                            <xsl:text>&#x0301;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:when>
            <xsl:when test="@rend = 'tall' or @rend = 'longa'">
                <xsl:attribute name="style">
                    <xsl:text disable-output-escaping="yes">font:14pt bold;</xsl:text>
                </xsl:attribute>   
                <xsl:if test="$count &lt; number(string-length(normalize-space(.)))">
                    <xsl:value-of select="upper-case(substring(normalize-space(.),$count+1,1))"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="@rend = 'superscript'">
                <xsl:attribute name="style">
                    <xsl:text disable-output-escaping="yes">vertical-align:super;</xsl:text>
                </xsl:attribute> 
                <xsl:if test="$count &lt; number(string-length(normalize-space(.)))">
                    <xsl:value-of select="substring(normalize-space(.),$count+1,1)"/>
                </xsl:if>
            </xsl:when>            
        </xsl:choose>            
        <xsl:choose>
            <xsl:when test="name(child::*[1]) != 'hi' and name(child::*[1]) != ''">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="name(child::*[1]) = 'hi'">
                <xsl:choose>
                    <xsl:when test="child::*[1]/@rend = 'supraline' and $count &lt; number(string-length(child::*[1]))">
                        <xsl:text>&#x0305;</xsl:text>
                    </xsl:when>
                    <xsl:when test="child::*[1]/@rend = 'ligature' and $count &lt; number(string-length(child::*[1])) and ($count mod 2) = 0">
                        <xsl:text>&#x0361;</xsl:text>
                    </xsl:when>  
                    <xsl:when test="child::*[1]/@rend = 'apex' and $count &lt; number(string-length(child::*[1]))">
                        <xsl:text>&#x0301;</xsl:text>
                    </xsl:when>
                    <xsl:when test="child::*[1]/@rend = 'superscript' and $count &lt; number(string-length(child::*[1]))">
                        <xsl:attribute name="style">
                            <xsl:text disable-output-escaping="yes">vertical-align:super;</xsl:text>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        </xsl:if>            
        </span>  
        <xsl:if test="$count &lt; number(string-length(normalize-space(.)))">
            <xsl:call-template name="hi">
                <xsl:with-param name="count" select="$count + 1"/>
            </xsl:call-template>
        </xsl:if> 
    </xsl:template>
    
    <xsl:template match="//usepi:orig">
        <xsl:text disable-output-escaping="yes">&lt;span style="font-style:italic" &gt;</xsl:text>
        <xsl:apply-templates/> 
        <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>
    </xsl:template>
    
    <xsl:template match="//usepi:lem">
        <xsl:text disable-output-escaping="yes">&lt;span style="text-decoration:underline" &gt;</xsl:text>
        <xsl:apply-templates/> 
        <xsl:text disable-output-escaping="yes">&lt;/span&gt;</xsl:text>        
    </xsl:template> 
    
 -->
</xsl:stylesheet>
