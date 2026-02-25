<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0" 
    exclude-result-prefixes="xs xd t"
    version="2.0">
 
        
    <xsl:param name="url" />
   
    <xsl:output method="xhtml" encoding="UTF-8" />
    <!--<xsl:output method="xml" encoding="UTF-8" exclude-result-prefixes="xs xd t" indent="yes"/>-->
    <xsl:preserve-space elements="*"/>
    
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 11, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> elli</xd:p>
            <xd:p>2021-08-02 EM Rewriting to handle new titles.xml</xd:p>
        </xd:desc>
    </xd:doc>
   
    <xsl:template match="/t:listBibl">
        <xsl:result-document href="#container" exclude-result-prefixes="xs xd t" >
            <hr />
                      
    <!--Corpora-->
            <h2 style="text-align:center;" id="corpus">Corpora</h2>
            
            
            <xsl:for-each-group select="t:bibl[@type='v-c']" group-by="t:title[@level='s']/@ref">
                <p xsl:exclude-result-prefixes="t"><a href="/../{concat($url, substring-after(current-grouping-key(),'#'))}"><xsl:value-of select="t:title[@level='s']"/></a> <span  class="bibID"><xsl:text> [</xsl:text><xsl:value-of select="substring-after(current-grouping-key(),'#')"/><xsl:text>]</xsl:text></span>
              <ul>
                  <xsl:for-each select="current-group()">
                  <li>
                      <a href="/../{concat($url, @xml:id)}"><xsl:value-of select="t:biblScope"/></a><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if></li>
                </xsl:for-each>
              </ul>
             </p>
            </xsl:for-each-group>
            
            
     <!-- Journal Articles Grouped by volume-->
            
            <xsl:text>
                
            </xsl:text><h2 style="text-align:center;" id="journal">Journal Articles</h2>
            
            <xsl:for-each-group select="t:bibl[@type='a-j']" group-by="t:title[@level='j']/@ref">
            
                <p><a href="/../{concat($url, substring-after(current-grouping-key(),'#'))}"><xsl:value-of select="preceding-sibling::t:bibl[@xml:id=substring-after(current-grouping-key(),'#')]/t:title"/></a> <span  class="bibID"><xsl:text> [</xsl:text><xsl:value-of select="substring-after(current-grouping-key(),'#')"/><xsl:text>]</xsl:text></span>
                <ul>
                    <xsl:for-each select="current-group()">
                        <xsl:sort select="t:biblScope[@unit='vol']" order="ascending"/>
                        
                        <li><xsl:variable name="author">
                            <xsl:choose>
                                <xsl:when test="t:author/t:persName[@type = 'sort']">
                                    <xsl:value-of select="concat(t:author/t:persName[@type = 'sort'], ', ')" />
                                </xsl:when>
                                <xsl:when test="t:author/t:persName">
                                    <xsl:value-of select="concat(t:author/t:persName, ', ')"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                            
                            <a href="/../{concat($url, @xml:id)}"><xsl:value-of select="$author"/>
                                <xsl:value-of select="concat('“', t:title[not(@level)][1], '”',', ')"/> 
                                <xsl:value-of select="t:biblScope[@unit='vol']"/>
                                <xsl:value-of select="concat(' (', t:date, ')')"/>.
                                <xsl:if test="t:biblScope[@unit='pp']">
                                    <xsl:value-of select="concat('pp. ',t:biblScope[@unit='pp'])"/>
                                </xsl:if>
                                
                            </a><!--<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>-->
                        </li>
                    </xsl:for-each>
                </ul>
                </p>
            </xsl:for-each-group>
            
      <!-- Monographs  -->
            <h2 style="text-align:center;" id="monograph">Monographs</h2>
            <xsl:for-each select="t:bibl[@type='m']">
                <xsl:variable name="author">
                    <xsl:choose>
                        <xsl:when test="t:author/t:persName[@type = 'sort']">
                            <xsl:value-of select="concat(t:author/t:persName[@type = 'sort'], ', ')" />
                        </xsl:when>
                        <xsl:when test="t:author/t:persName">
                           <xsl:value-of select="concat(t:author/t:persName, ', ')"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                
                <p><a href="/../{concat($url, @xml:id)}"><xsl:value-of select="$author"/> <xsl:value-of select="t:title"/> <xsl:value-of select="concat(' (', t:date, ')')"/></a> <span  class="bibID"><xsl:text> [</xsl:text><xsl:value-of select="@xml:id"/><xsl:text>]</xsl:text></span></p>
                
            </xsl:for-each>   
            
       <!-- Unpublished  -->
            <h2 style="text-align:center;" id="unpub">Unpublished/Missing Citations</h2>
               
            END
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="*"/>
  
    
</xsl:stylesheet>
