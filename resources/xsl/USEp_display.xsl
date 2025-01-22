<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:xi="http://www.w3.org/2001/XInclude" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs xd t" version="2.0">

    <!-- ******************************************************************************
        Takes an inscription marked up in Epidoc (US Ep version, Winter 2011) and
        transforms it to HTML for display. This is based on the US Ep proofreading
        XSL and on the original USEp display XSL.
        **Change Log
        2011-11-8 EM Begun
        2011-11-29 EM adding edition handling
        2014-09-25 EM many changes including:
        2015-9-15 SJD and EM rewrote image display to accomodate graphics from external webpages
        2015-09-29 SJD Added variables, added concat to remove excess commas
        2015-09-30 EM testing the acquisition field with no variable
        2015-10-06 SJD Added string-length tests to remove commas
        2015-10-13 SJD added variables and tests for Layout, Writing, Condition
        2015-10-20 SJD fixing display xsl for writing, layout, condition; fixed path errors in dateOfProvenance and acquisitionDate variables
        2015-10-21 SJD small fixes to display (removed all stray commas)
        2015-10-21 SJD fixed display of transcribed texts with multiple divs
        2015-11-02 SJD made small change to columns display
        2015-11-17 SJD made expansions to columns and line display (added tests for wider ranger of situations)
        2015-11-18 SJD added captions to image display
        2015-11-19 SJD Fixed column displays, removed stray periods from title heading; small tweaks to fix caption display
        2015-11-24 SJD Added support for lg in displaying transcription
        2015-12-02 SJD Added variable for material
        2016-01-19 SJD Small tweak to column display
        2016-01-21 SJD Fixed typo in provenance, added display of descriptions for provenance/acquisition
        2016-03-02 SJD Made fixes to allow multiple provenance elements to display correctly
        2016-11-10 EM change to display XML button to view source
        2017-06-29 SJD separated Date of Origin and Place of Origin into two distinct categories
        2017-07-14 SJD tweaked spacing of external links in bibl; renamed Date of Origin to Date
        2018-08-08 SJD fixes issues with provenance to display according to desired categories; added table display for authorship
        2019-11-14 SJD fixed main issue with authorship display, pushed alpha version to site
        2020-01-30 SJD reordered major metadata categories, display orders of transcription per JB's design requests; commented out editor display privileging authorial creation
        2020-03-11 SJD temporarily disabled authorship display, pending reconsideration of how to handle
        2020-05-19 SJD disabled Acquisition info, relabeled the provenance into new category as previously discussed
        2020-06-24 SJD added display for dating criteria
        2020-10-22 SJD commented out display of decoNote/@ana
        2021-03-31 SJD added date-sorting to bibl handling, fixed dating display issues
        2021-07-29 EM added bibliography processing.
        2025-01-21 SJD improved display of campus dimensions as separate area, turned on Pleiades links, enabled display of multiple dating criteria
        ******************************************************************************   -->

    <xsl:output indent="yes" encoding="UTF-8" method="xml"/>
    <xsl:variable name="imageDir" select="'../../../../usep_images'"/>

    <xsl:include href="epidoc-xsl-p5/start-edition.xsl"/>

    <!-- Output is not complete HTML file, because in our case, most of the page, header and so on are handled by django.
        This script takes care of anything beneath the title of the inscription (handled by django) down to the bibliographic
        citations and the images. -->

    <xsl:template match="/">
        <xsl:result-document href="#container">
            <div>

                <!-- This outputs the full text description at the top of the page, after checking that there are descriptions to output. -->
                <div class="titleBlurb">
                    <xsl:if test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/*">
                        <h3>Summary</h3>
                        <p><xsl:value-of
                                select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:msItem/t:p"/>.<br/>
                            <xsl:if
                                test="string(normalize-space(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:support/t:p))">
                                <xsl:value-of
                                    select="concat(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:support/t:p, '.')"
                                />
                            </xsl:if>
                        </p>
                    </xsl:if>
                </div>



                <!-- enclosing div so that metadata and images can be side by side -->
                <div class="topDivs">
                  <!-- This outputs the text using Epidoc stylesheets, checks to see if there is a transcription. -->
                  <xsl:if
                      test="/t:TEI/t:text/t:body/t:div[@type = 'edition']/t:ab/t:lb or /t:TEI/t:text/t:body/t:div[@type = 'edition']/t:lg or /t:TEI/t:text/t:body/t:div[@type = 'edition']/t:div[@type = 'textpart']">
                      <div class="transcription">
                        <h3>Transcription</h3>
                      <style id="transcription_style">
                          .linenumber{
                              display:block;
                              float:left;
                              margin-left:-2em;
                          }</style>
                      <xsl:call-template name="default-body-structure">
                          <xsl:with-param name="parm-leiden-style" tunnel="yes"
                              >panciera</xsl:with-param>
                          <xsl:with-param name="parm-line-inc" tunnel="yes" as="xs:double"
                              >5</xsl:with-param>
                          <xsl:with-param name="parm-bib" tunnel="yes">none</xsl:with-param>
                      </xsl:call-template>
                      </div>
                  </xsl:if>
                    <!-- This outputs the inscription metadata, after checking that there is some. -->
                    <xsl:if test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/*">
                        <div class="metadata">
                            <h3>Attributes</h3>
                            <!-- variables -->
                            <xsl:variable name="placeOfOrigin"
                                select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/t:placeName"/>
                            <xsl:variable name="dateOfOrigin" select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/t:date"/>                               
                            <xsl:variable name="placeOfOrigin"
                                select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:origin/t:placeName"/>
                            <!-- <xsl:variable name="placeOfProvenance">
                                <xsl:sequence
                                    select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:provenance/t:p"
                                />
                            </xsl:variable>
                           <xsl:variable name="dateOfProvenance"
                                select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:provenance/t:date"/>
                            <xsl:variable name="acquisitionDesc">
                                <xsl:sequence
                                    select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:acquisition/t:p"
                                />
                            </xsl:variable>
                            <xsl:variable name="acquisitionDate"
                                select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:history/t:acquisition/t:date"/> -->
                            <xsl:variable name="condition"
                                select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:condition"/>
                            <xsl:variable name="layout"
                                select="t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:layoutDesc/t:layout"/>
                            <xsl:variable name="writing"
                                select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:handDesc/t:handNote"/>
                            <xsl:variable name="material"
                                select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/@ana"/>

                            <!-- end variables -->

                            <table>
                                <tr>
                                    <td class="label">Inscription Type</td>
                                    <td class="value">
                                        <xsl:value-of
                                            select="id(substring-after(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:msItem/@class, '#'))/t:catDesc"
                                        />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Object Type</td>
                                    <td class="value">
                                        <xsl:value-of
                                            select="id(substring-after(/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/@ana, '#'))/t:catDesc"
                                        />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Material</td>
                                    <td class="value">
                                
                                            <xsl:for-each select="tokenize(normalize-space($material), '\s+')">
                                                <xsl:value-of select="id(substring-after(., '#'))/t:catDesc"/>
                                                <xsl:if test="position() != last()">
                                                    <xsl:text>, </xsl:text>
                                                </xsl:if>
                                            </xsl:for-each>
                                        
                                    </td>
                                </tr>

                                <!-- Add objection dimensions -->
                                <tr>
                                    <td class="label">Object Dimensions</td>
                                    <td class="value">
                                        <xsl:for-each select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:support/t:dimensions[@type = 'surface']">
                                            
                                                <xsl:if test="t:width/text()">w: 
                                                    <xsl:value-of select="t:width"/>
                                                    <xsl:if test="t:height/text()"> x
                                                    </xsl:if>
                                                </xsl:if>
                                                <xsl:if test="t:height/text()">h:
                                                    <xsl:value-of select="t:height"/>
                                                </xsl:if>
                                                <xsl:if test="t:depth/text()"> x d:
                                                    <xsl:value-of select="t:depth"/>
                                                </xsl:if>
                                                <xsl:if test="t:dim[@type='diameter']/text()">x diam.:
                                                    <xsl:value-of select="t:dim[@type='diameter']"/>
                                                </xsl:if>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                                
                                <!-- Add campus dimensions -->
                                <xsl:if test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:support/t:dimensions[@type = 'campus']">
                                    <tr>
                                    <td class="label">Campus Dimensions</td>
                                    <td class="value">
                                        <xsl:for-each select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:objectDesc/t:supportDesc/t:support/t:dimensions[@type = 'campus']">
                                            
                                            <xsl:if test="t:width/text()">w: 
                                                <xsl:value-of select="t:width"/>
                                                <xsl:if test="t:height/text()"> x
                                                </xsl:if>
                                            </xsl:if>
                                            <xsl:if test="t:height/text()">h:
                                                <xsl:value-of select="t:height"/>
                                            </xsl:if>
                                            <xsl:if test="t:depth/text()"> x d:
                                                <xsl:value-of select="t:depth"/>
                                            </xsl:if>
                                            <xsl:if test="t:dim[@type='diameter']/text()">x diam.:
                                                <xsl:value-of select="t:dim[@type='diameter']"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                                </xsl:if>
                                
                                       
                                <!-- check for existence of controlled and full text values here. -->
                                <tr>
                                    <td class="label">Writing</td>
                                    <td class="value">
                                        <xsl:choose>
                                            <xsl:when
                                                test="string-length($writing/@ana) != 0 and normalize-space($writing)">
                                                <xsl:value-of
                                                  select="concat(id(substring-after($writing/@ana, '#'))/t:catDesc, ', ', $writing/t:p)"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="id(substring-after($writing/@ana, '#'))/t:catDesc"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                              
                                <!-- Add letter dimensions -->
                                <tr>
                                    <td class="label">Letter Dimensions</td>
                                    <td class="value">
                                        <xsl:for-each select="$writing/t:dimensions">  
                                    <xsl:if test="$writing/t:width/text()">w: 
                                        <xsl:value-of select="t:width"/>
                                        <xsl:if test="t:height/text()"> x 
                                        </xsl:if>
                                    </xsl:if>
                                    <xsl:if test="t:height/text()">h: 
                                        <xsl:value-of select="t:height"/>
                                    </xsl:if>
                                    <xsl:if test="t:depth/text()"> x d:
                                        <xsl:value-of select="t:depth"/>
                                    </xsl:if>   
                                </xsl:for-each>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Layout</td>
                                    <td class="value">
                                        <xsl:choose>
                                            <xsl:when
                                                test="string-length($layout/@columns) != 0 and string-length($layout/@writtenLines) != 0 and $layout/@columns > '1'">
                                                <xsl:value-of
                                                  select="concat($layout/@columns, ' columns, ', $layout/@writtenLines, ' lines')"
                                                />
                                            </xsl:when>
                                            <xsl:when
                                                test="string-length($layout/@columns) != 0 and string-length($layout/@writtenLines) != 0 and $layout/@columns = '1' and $layout/@writtenLines = '1'">
                                                <xsl:value-of
                                                  select="concat($layout/@columns, ' column, ', $layout/@writtenLines, ' line')"
                                                />
                                            </xsl:when>
                                            <xsl:when
                                                test="string-length($layout/@columns) != 0 and string-length($layout/@writtenLines) != 0 and $layout/@columns > '1' and $layout/@writtenLines = '1'">
                                                <xsl:value-of
                                                  select="concat($layout/@columns, ' columns, ', $layout/@writtenLines, ' line')"
                                                />
                                            </xsl:when>
                                            <xsl:when
                                                test="string-length($layout/@columns) != 0 and string-length($layout/@writtenLines) != 0 and $layout/@columns = '1' and $layout/@writtenLines > '1'">
                                                <xsl:value-of
                                                  select="concat($layout/@columns, ' column, ', $layout/@writtenLines, ' lines')"
                                                />
                                            </xsl:when>
                                            <xsl:when
                                                test="$layout/@columns = '0' and string-length($layout/@writtenLines) != 0 and $layout/@writtenLines = '1'">
                                                <xsl:value-of
                                                  select="concat($layout/@writtenLines, ' line')"/>
                                            </xsl:when>
                                            <xsl:when
                                                test="$layout/@columns = '0' and string-length($layout/@writtenLines) != 0 and $layout/@writtenLines != '1'">
                                                <xsl:value-of
                                                  select="concat($layout/@writtenLines, ' lines')"/>
                                            </xsl:when>
                                        </xsl:choose>

                                    </td>
                                </tr>

                                <tr>
                                    <td class="label">Decoration</td>
                                    <td class="value">
                                        <!--<xsl:value-of
                                            select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:decoDesc/t:decoNote/@ana"/>-->
                                        <xsl:value-of
                                            select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:physDesc/t:decoDesc/t:decoNote"
                                        />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Condition</td>
                                    <td class="value">
                                        <xsl:choose>
                                            <xsl:when
                                                test="normalize-space($condition/t:p) and string-length($condition/@ana) != 0">
                                                <xsl:value-of
                                                  select="concat(id(substring-after($condition/@ana, '#'))/t:catDesc, ', ', $condition/t:p)"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                  select="id(substring-after($condition/@ana, '#'))/t:catDesc"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Place of Origin</td>
                                    <td class="value">
                                       <!-- <xsl:for-each select="$placeOfOrigin">
                                            <xsl:choose>
                                               <xsl:when test="contains(@ref,'pleiades.stoa.org') or contains(@ref,'geonames.org') or contains(@ref,'slsgazetteer.org')">
                                                    <a>
                                                        <xsl:text>
                                                            <xsl:value-of select="$placeOfOrigin"
                                                        </xsl:text>
                                                         <xsl:attribute name="href">
                                                              <xsl:value-of select="@ref"/>
                                                          </xsl:attribute>
                                                    </a>
                                        </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="$placeOfOrigin"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each> -->
                                                                                <xsl:value-of select="$placeOfOrigin"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Date</td>
                                    <td class="value">
                                        <xsl:value-of select="$dateOfOrigin"/>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="label">Dating Criteria</td>
                                     <td class="value">
                                         <xsl:for-each select="$dateOfOrigin/@evidence">
                                             <xsl:value-of
                                                 select="id(substring-after($dateOfOrigin/@evidence, '#'))/t:catDesc"/>
                                             <xsl:if test="position() != last()">
                                                 <xsl:text>, </xsl:text>
                                             </xsl:if>
                                         </xsl:for-each>
                                    </td>
                                </tr>
                                
                                <xsl:for-each select="//t:provenance">
                                    <tr>
                                        <td class="label">Object History</td>
                                        <td class="value">
                                            <xsl:choose>
                                                <xsl:when
                                                    test="string-length(child::t:p) != 0">
                                                    <xsl:value-of
                                                        select="(child::t:p)"/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </td>
                                    </tr>
                                </xsl:for-each>
                                <!--  <tr>
                                    <td class="label">Acquired</td>
                                    <td class="value">
                                        <xsl:choose>
                                            <xsl:when test="string-length($acquisitionDesc) != 0">
                                                <xsl:value-of
                                                  select="concat($acquisitionDate, ', ', $acquisitionDesc)"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="$acquisitionDate"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </td>
                                </tr>-->
                            </table>
                        </div>
                    </xsl:if>


<!-- Print links to Pleiades when they appear in texts or metadata -->
                   
                    <xsl:for-each select="t:placeName">
                        <xsl:choose>
                            <xsl:when test="contains(@ref,'pleiades.stoa.org') or contains(@ref,'geonames.org') or contains(@ref,'slsgazetteer.org')">
                                <a>
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="@ref"/>
                                    </xsl:attribute>
                                    <xsl:apply-templates/>
                                </a>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                
                    <!-- Output the images (hope to format these at upper  right perhaps?), again, first checking to see if there are any. -->
                    <xsl:result-document href="#images">
                        <xsl:for-each select="/t:TEI/t:facsimile/t:surface">
                            
                            <xsl:for-each select="t:graphic">
                                <xsl:choose>
                                    <xsl:when test="starts-with(@url, 'http')">
                                        <a class="highslide" href="{@url}"
                                            onclick="return hs.expand(this)">
                                            <img src="{@url}" alt="" width="200"/>
                                        </a>
                                        <xsl:value-of select="preceding-sibling::t:desc"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <a class="highslide" href="{concat($imageDir, '/',@url)}"
                                            onclick="return hs.expand(this)">
                                            <img src="{concat($imageDir, '/',@url)}" alt=""
                                                width="200"/>
                                        </a>
                                        <xsl:value-of select="preceding-sibling::t:desc"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:result-document>
                </div>
                

                <!-- This outputs the bibliography. No need to check, there is always bibliography. -->
                <div class="bibl">
                    <h3>Bibliography</h3>
                    <xsl:call-template name="bibl"/>

                    <!-- this should be enclosed in a bibl and put into the bibliography script,
                            it should also check that link is descendant of div type=bib -->

                </div>

                <xsl:choose>
                    <xsl:when
                        test="/t:TEI/t:text/t:body/t:div[@type = 'edition']/t:ab/t:lb or /t:TEI/t:text/t:body/t:div[@type = 'edition']/t:lg or /t:TEI/t:text/t:body/t:div[@type = 'edition']/t:div[@type = 'textpart']">
                        <!-- transcribed folder -->
                        <pc class="XMLsource">
                            <a href="{concat('https://github.com/Brown-University-Library/usep-data/blob/master/xml_inscriptions/transcribed/',/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno/@xml:id,'.xml')}">
                                <img style="height:50px;" src="{concat($imageDir, '/xmlIcon.png')}"/>
                            </a>
                        </pc>
                    </xsl:when>
                    <xsl:when
                        test="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msContents/t:msItem[@class]">
                        <!-- bib only folder -->
                        <p class="XMLsource">
                            <a
                                href="{concat('https://github.com/Brown-University-Library/usep-data/blob/master/xml_inscriptions/metadata_only/',/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno/@xml:id,'.xml')}">
                                <img style="height:50px;" src="{concat($imageDir, '/xmlIcon.png')}"/>
                            </a>
                        </p>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- only option left is metadata only -->
                        <p class="XMLsource">
                            <a
                                href="{concat('https://github.com/Brown-University-Library/usep-data/blob/master/xml_inscriptions/bib_only/',/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno/@xml:id,'.xml')}">
                                <img style="height:50px;" src="{concat($imageDir, '/xmlIcon.png')}"/>
                            </a>
                        </p>
                    </xsl:otherwise>
                </xsl:choose>




            </div>
            <!-- ****** Author/Editor Information ****** 


                <div class="author">
                    <table>
                      <xsl:for-each select="//t:change">
                        <tr>
                        <xsl:choose>
                            <xsl:when test="position()=1">
                                <td type="label">Author: </td>
                                <td type="value"><xsl:value-of select="concat(@who, ' on: ', @when)"/></td>
                            </xsl:when>
                            <xsl:otherwise>
                                <td type="label">Edited by: </td>
                                <td type="value">
                                    <xsl:value-of select="concat(@who, ' on: ', @when)"/>
                                </td>
                            </xsl:otherwise>
                        </xsl:choose>
                        </tr>
                    </xsl:for-each>

                    </table>
                </div> -->
        </xsl:result-document>
    </xsl:template>



    <!-- ****************** This outputs the bibliography ******************** -->

    <xsl:template name="bibl">        
        <xsl:for-each select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:listBibl/t:bibl[child::t:ptr[@type='rest-of-bibl']]">
            <xsl:sort select="id(substring-after(t:ptr/@target, '#'))/t:date[1]/@when" order="ascending"/> <!-- @data-type="number"  -->
           
            <xsl:variable name="myID" select="substring-after(t:ptr/@target, '#')"/>
            <p>
                <!-- Output the author, if there is one. Right now, assumption is that there is an
                    potentially an author on the bibl if it's an article, or on the outermost bibl if
                    it's a corpus or monograph. Corpora don't have authors in the inscription bibliography. 
                    Use <persName type="sort"> if it's there. Otherwise use the first <persName>
                -->
                <xsl:if test="id($myID)/t:author[1]/t:persName">
                    <xsl:choose>
                        <xsl:when test="id($myID)/t:author[1]/t:persName[@type = 'sort']">
                          <xsl:value-of
                                select="concat(id($myID)/t:author[1]/t:persName[@type = 'sort'], ', ')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(id($myID)/t:author[1]/t:persName, ', ')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
               
                <!-- output title or abbreviation. if it's a monograph, journal article or edited volume article, output the title. 
                    If it's a corpus volume, just output the corpus abbreviation (from corpus bibl entry). Ideally, these might link to their entries in the 
                    Citations page, at some future time.
                -->

                <xsl:choose>

     <!-- single-volume corpus -->
                    <xsl:when test="id($myID)/self::t:bibl[@type = 'c']">
                        <i><xsl:value-of
                            select="id($myID)/self::t:bibl[@type = 'c']/t:abbr[@type = 'primary']"/></i>
                    </xsl:when>
                  
         <!-- monograph or unpublished type="m" type="u"-->
                    <xsl:when test="id($myID)/self::t:bibl[@type = 'm' or @type = 'u']">
                        <i><xsl:value-of
                                select="id($myID)/self::t:bibl[@type = 'm' or @type = 'u']/t:title"/></i>
                    </xsl:when>
                    
       <!-- corpus volume type="v-c" or journal volume type="v-j" -->
                    <xsl:when test="id($myID)/self::t:bibl[@type = 'v-c' or @type= 'v-j']">
                      <i><xsl:value-of select="id(substring-after(id($myID)/self::t:bibl/t:title[@level='c' or @level='j']/@ref, '#'))/self::t:bibl/t:abbr[@type='primary']"/></i>
                    </xsl:when>
                    
        <!-- volume in a monograph type="v-m" These are separate volumes, and don't have titles of their own. Treat like
              corpus volumes, but instead of abbreviation, use title. -->
                    <xsl:when test="id($myID)/self::t:bibl[@type = 'v-m']">
                        <i><xsl:value-of select="id(substring-after(id($myID)/self::t:bibl/t:title[@level='m']/@ref, '#'))/self::t:bibl/t:title"/></i>
                    </xsl:when>
                    
         <!-- journal article type="a-j" -->
                    <xsl:when test="id($myID)/self::t:bibl[@type = 'a-j']">
                        <xsl:text>“</xsl:text><xsl:value-of select="id($myID)/self::t:bibl[@type = 'a-j']/t:title[not(@level)]"/><xsl:text>”, </xsl:text> 
                        <i><xsl:value-of select="id(substring-after(id($myID)/self::t:bibl/t:title[@level='j']/@ref, '#'))/self::t:bibl/t:abbr[@type='primary']"/> </i>
                    </xsl:when>
                                        
        <!-- monograph article type="a-m"  (edited volume) -->
                    <xsl:when test="id($myID)/self::t:bibl[@type = 'a-m']">
                        <xsl:text>“</xsl:text><xsl:value-of select="id($myID)/self::t:bibl[@type = 'a-m']/t:title"/><xsl:text>” in </xsl:text>
                        <xsl:value-of select="id(substring-after(id($myID)/self::t:bibl/t:title[@level='m']/@ref, '#'))/self::t:bibl/t:abbr[@type='primary']"/>
                    </xsl:when>
                    
                </xsl:choose>

                <!-- output the volume, if there is one. with a space before it. -->

                <xsl:if test="id($myID)/self::t:bibl/t:biblScope[@unit='vol']">
                    <xsl:choose>
                        <xsl:when test="substring-before($myID,'_')='AE'"/>
                        <xsl:otherwise><xsl:value-of select="concat(' ', id($myID)/self::t:bibl/t:biblScope[@unit='vol'])"/></xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:if>

                <!-- output the year, if there is one. with a space before it and inside parentheses. -->
                <xsl:if  test="id($myID)/t:date">
                    <xsl:value-of select="concat(' (', id($myID)/t:date[1], ')')"/>
                </xsl:if>
        
                

                <!-- everything has a reference except for unpub. but put a space before it. -->
                <!-- if there is no date, don't output the : that would appear after the parenthesis -->

                <xsl:if test="./t:biblScope">
                    <xsl:choose>
                        <xsl:when test="id($myID)/t:date">
                             <xsl:value-of select="concat(': ', ./t:biblScope)"/>
                         </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(' ', ./t:biblScope)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
                
                <!-- This prints the jstor link   -->
                <xsl:if test="id($myID)/t:ref[@type = 'jstor']">
                    <br/>
                    <a href="{id($myID)/t:ref/@target}" class="biblink"><xsl:text>[JSTOR]</xsl:text></a>
                    
                </xsl:if>
                
                <xsl:if test="id($myID)/t:ref[@subtype='OA']">
                  <xsl:text> </xsl:text> <img src="https://upload.wikimedia.org/wikipedia/commons/2/25/Open_Access_logo_PLoS_white.svg"  style="height:25px;"/>  
                </xsl:if>
                
 
            </p> 
            
        </xsl:for-each>
        
        <xsl:for-each select="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:listBibl/t:bibl[child::t:ref[@type='external']]">
           <p> <a href="{t:ref/@target}" class="biblink">
               <xsl:value-of select="t:ref"/></a></p>
           
        </xsl:for-each>
        
           
        
    </xsl:template>


</xsl:stylesheet>
