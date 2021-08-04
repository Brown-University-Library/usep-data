<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:t="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs xd"
    version="2.0">
    
    <xsl:param name="url" />
   
    
    <xsl:output method="xhtml" encoding="UTF-8" />
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Apr 11, 2014</xd:p>
            <xd:p><xd:b>Author:</xd:b> elli</xd:p>
            <xd:p>Rewriting to handle new titles.xml</xd:p>
        </xd:desc>
    </xd:doc>
    <xsl:strip-space elements="*"/>
    <xsl:template match="/t:listBibl">
        <xsl:result-document href="#container">
            <hr />
           
            <!--      <p><a href="/../{concat($url, normalize-space(./@xml:id))}"><xsl:apply-templates select="t:title"/></a> <span  class="bibID"><xsl:value-of select="@xml:id"/></span>
            
            <p><a href="/../{concat($url, substring-after(current-grouping-key(),'#')}"><xsl:value-of select="t:title[@level='c'"/></a> <span  class="bibID"><xsl:value-of select="substring-after(current-grouping-key(),'#')"/></span>
            -->
            
    <!--Corpora-->
            <h2 style="text-align:center;" id="corpus">Corpora</h2>
            
            
            <xsl:for-each-group select="t:bibl[@type='v-c']" group-by="t:title[@level='c']/@ref">
                <p><a href="/../{concat($url, substring-after(current-grouping-key(),'#'))}"><xsl:value-of select="t:title[@level='c']"/></a> <span  class="bibID"><xsl:value-of select="substring-after(current-grouping-key(),'#')"/></span>
                    
               <!-- <h3><xsl:value-of select="preceding-sibling::t:bibl[@xml:id=substring-after(current-grouping-key(),'#')]/t:abbr[@type='primary']"/></h3>-->
                <ul>
                <xsl:for-each select="current-group()">
                    <li>
                    <xsl:value-of select="t:biblScope"/>
                        <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                    </li>
                </xsl:for-each>
                </ul>
                </p>
            </xsl:for-each-group>
            
            
     <!-- Journal Articles Grouped by volume-->
            
            <h2 style="text-align:center;" id="journal">Journal Articles</h2>
            <xsl:for-each-group select="t:bibl[@type='a-j']" group-by="t:title[@level='j']/@ref">
                
                <h3><xsl:value-of select="preceding-sibling::t:bibl[@xml:id=substring-after(current-grouping-key(),'#')]/t:abbr[@type='primary']"/></h3>
                <ul>
                    <xsl:for-each select="current-group()">
                        <li>
                            <xsl:value-of select="t:biblScope"/>
                            <xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
                        </li>
                    </xsl:for-each>
                </ul>
            </xsl:for-each-group>
            
      <!-- Monographs  -->
            <h2 style="text-align:center;" id="monograph">Monographs</h2>
            <xsl:for-each select="t:bibl[@type='m']">
                
                <h3><xsl:value-of select="t:title"/></h3>
                
            </xsl:for-each>   
            
       <!-- Unpublished  -->
            <h2 style="text-align:center;" id="unpub">Unpublished/Missing Citations</h2>
               <xsl:apply-templates mode="unpub" />
           
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='u']" mode="unpub">
        <p><a href="/../{concat($url, normalize-space(./@xml:id))}"><xsl:apply-templates select="t:title"/></a> <span  class="bibID"><xsl:value-of select="@xml:id"/></span></p>
    </xsl:template>
    
    
    <!--<xsl:template match="t:bibl[@type='c']" mode="corpus">
        <xsl:choose>
            <xsl:when test="$new">
                <p><a href="/../{concat($url, normalize-space(./@xml:id))}"><xsl:apply-templates select="t:title"/></a> <span class="bibID"><xsl:value-of select="@xml:id"/></span>
                    <ul>
                        <xsl:apply-templates select="./t:bibl" mode="parent" />
                    </ul>   
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p><a href="/../{concat($url, normalize-space(t:title))}"><xsl:apply-templates select="t:title"/></a> <span class="bibID"><xsl:value-of select="t:biblScope"/></span></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='j']" mode="journal">
        <xsl:choose>
            <xsl:when test="$new">
                <p><a href="/../{concat($url, normalize-space(./@xml:id))}"><xsl:apply-templates select="t:title"/></a> <span class="bibID"><xsl:value-of select="@xml:id"/></span>
                    <ul>
                        <xsl:apply-templates select="./t:bibl" mode="parent" />
                    </ul>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p><a href="/../{concat($url, normalize-space(t:title))}"><xsl:apply-templates select="t:title"/></a> <span class="bibID"><xsl:value-of select="@xml:id"/></span></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="t:bibl[@type='m']" mode="monograph">
        <xsl:choose>
            <xsl:when test="$new">
                <p><a href="/../{concat($url, normalize-space(./@xml:id))}"><xsl:apply-templates select="t:title"/></a> <span  class="bibID"><xsl:value-of select="@xml:id"/></span>
                    <ul>
                        <xsl:apply-templates select="./t:bibl" mode="parent" />
                    </ul>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <p><a href="/../{concat($url, normalize-space(t:title))}"><xsl:apply-templates select="t:title"/></a> <span  class="bibID"><xsl:value-of select="@xml:id"/></span></p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <xsl:template match="t:bibl[@type='v']" mode="parent">
        <li><a href="/../{concat($url, normalize-space(./@xml:id))}"> 
            <!-\-  This outputs the abbrevations next to individual volume entries for corpora
              <xsl:choose>
                <xsl:when test="ancestor::t:bibl[@type='c']">
                    corpus, display abbr
                    <xsl:value-of select="ancestor::t:bibl[@type='c']/t:abbr[@type='primary']" />
                    <xsl:text> </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    not a corpus, display vol
                    <xsl:text>vol. </xsl:text>
                </xsl:otherwise>
             </xsl:choose>  -\->
            
            <xsl:choose>
                <xsl:when test="t:biblScope">
                    <xsl:value-of select="t:biblScope" />
                </xsl:when>
                <xsl:otherwise>                
                    <xsl:if test="t:date">
                        <xsl:value-of select="t:date" />
                    </xsl:if>
                    
                </xsl:otherwise>
            </xsl:choose>
            <!-\- abbr: <xsl:value-of select="t:abbr[@type='primary']" />
            num: <xsl:value-of select="t:biblScope/t:num/@value" />
            date: <xsl:value-of select="t:date" /> @when: <xsl:value-of select="t:date/@when" />
            biblScope: <xsl:value-of select="t:biblScope" /> -\->
        </a></li>
    </xsl:template>
    <xsl:template match="t:bibl[@type='a']" mode="parent"/>
    
    
    <xsl:template match="t:title" mode="#all">
        <i><xsl:value-of select="."/></i>.
    </xsl:template>
    
    <xsl:template match="t:abbr[@type='primary']" mode="corpus journal">
        <xsl:value-of select="concat('[',.,'] ')"/>
    </xsl:template>
    
    <xsl:template match="t:title" mode="#all">
        <i><xsl:value-of select="."/></i>.
    </xsl:template>
    
    <xsl:template match="t:date" mode="#all">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="*" mode="#all"/>-->
    
</xsl:stylesheet>
