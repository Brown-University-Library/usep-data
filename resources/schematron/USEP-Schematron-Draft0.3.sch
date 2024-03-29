<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" 
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:t="http://www.tei-c.org/ns/1.0">
    <sch:ns uri="http://www.tei-c.org/ns/1.0" prefix="t"/>
    
    
    <!--*******
    This provides validation for encoders while working on their transcriptions. The transcription-oriented are drawn from the sample schematron provided on the EpiDoc sourceforge,
    with several customizations for the US Epigraphy Project added, especially with respect to bibliography and metadata.
    **Change log:
    2015-11-02 SJD began; took transcription rules from sourceforge and adding rules for IDs and file names, image names, empty bibliography, image formatting
    2015-11-03 SJD added variable and put into schematron 1.7, working on simplifying the test for matching machine-readable id and itemized elements
    2015-11-04 SJD added rules for empty genre, support type, material, condition, handNote, location, date, and change log
    2016-02-22 SJD 
    2018-10-27 EM - Corrected spelling of "sourcDesc" in variable assignments.
                    Changed idno[@xml:id] to idno/@xml:id 
                    Changed id/name rule to check filename (see comment below)
                    NOTE that in Oxygen, need to change Schematron rules to use XSLT2
                    Added ns prefix for schematron. Seems to have helped. 
                    Added diagnostics
   2023-06-15 EM - Minor typos and fixes to make rules work. 
                  Updated rule testing graphics names to use path, not qualifiers
                  Updated bibliography checks. One with context listBibl, the other with context bibl.
                  
    -->
   
    <!-- Variable declaration -->
    <sch:let name="region" value="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:region"/>
    <sch:let name="settlement" value="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:settlement"/>
    <sch:let name="institution" value="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:institution"/>
    <sch:let name="repository" value="/t:TEI/t:teiHeader/t:fileDesc/t:sourceDesc/t:msDesc/t:msIdentifier/t:repository"/>
    <sch:let name="xmlid" value="/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno/@xml:id"/>
    
    <!-- Test machine readable name -->
    
    <sch:pattern>
        <sch:title>Test machine readable name</sch:title>
        <sch:rule context="//t:publicationStmt">
            <sch:assert diagnostics="docTest" test=" contains(document-uri(/), t:idno/@xml:id)">Machine-Readable ID must match filename</sch:assert>
            <!-- I'm cheating here, just looking to see if the ID is in the fn. Usually people have 
            completely wrong ID so this will catch most of those -->
        </sch:rule>
    </sch:pattern>
    
    <!-- Test machine readable id against broken out version -->
    <sch:pattern>
        <sch:rule context="/">
            <sch:assert diagnostics="USEPID-start" test="starts-with($xmlid, concat($region,'.', $settlement,'.', $institution,'.', $repository)) or starts-with($xmlid, concat($region, '.', $settlement, '.', $institution))">USEP ID must match the individual elements listed in the itemized section</sch:assert>
            <!--<sch:assert diagnostics="USEPID-accession" test="matches(substring-after($xmlid, 'L\.'), //t:msIdentifier/t:idno)">ID no. must match end of USEP ID</sch:assert> -->   
        </sch:rule>         
    </sch:pattern>


    <!-- Test for empty genre -->
    <sch:pattern>
        <sch:rule context="//t:msContents">
            <sch:report test="//t:msItem[@class='#xx']">Every inscription must have a valid genre</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Test for empty support material -->
    <sch:pattern>
        <sch:rule context="//t:physDesc">
            <sch:report test="//t:supportDesc[@ana='#xx']">Every inscription must have a valid material</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Test for empty condition -->
    <sch:pattern>
        <sch:rule context="//t:physDesc/t:objectDesc/t:supportDesc/t:condition">
            <sch:report test="//t:condition[@ana='#xx']">Every inscription must have a valid condition</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Test for multiple ps under supportDesc -->
    <sch:pattern>
        <sch:rule context="//t:physDesc">
            <sch:report test="//t:supportDesc/t:support/t:p[2]">Cannot have two p-elements in the support element</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Test for empty objectDesc -->
    <sch:pattern>
        <sch:rule context="//t:physDesc">
            <sch:report test="//t:objectDesc[@ana='#xx']">Every entry must contain a valid object type</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Test for empty handNote -->
    <sch:pattern>
        <sch:rule context="//t:physDesc/t:handDesc">
            <sch:report test="//t:handNote[@ana='#xx']">Every entry must contain a valid writing description; if unknown, mark as such</sch:report>
        </sch:rule>
    </sch:pattern>
    
   <!-- Test for unknown dates with year ranges -->
    <sch:pattern>
        <sch:rule context="//t:date[@evidence='#unknown' or .='unknown']">
            <sch:report test="(@notBefore, @notAfter)">There should be no date ranges when the date is unknown. Please delete the attributes completely.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Test for empty date fields -->
    <sch:pattern>
        <sch:rule context="//t:history//t:date">
            <sch:report test=".='Date to be displayed'">Enter a date for the inscription</sch:report>
            <sch:report test="@notBefore='0001' and @notAfter='0002'">Enter a range of dates for the inscription</sch:report>
        </sch:rule>
    </sch:pattern>
    
    
    
    <!-- Test for empty place names -->
    <sch:pattern>
        <sch:rule context="//t:history/t:origin">
            <sch:report test="t:placeName[@ref='xx']">Inscription must have a valid place ref (e.g. europe.italy.rome)</sch:report>
            <sch:report test="t:placeName='Detailed place name'">Inscription must have a location; if it is unknown, mark as such</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Test for empty bibl -->
    <sch:pattern>
        <sch:rule context="//t:listBibl">
           <!-- <sch:assert test="normalize-space(.)">Every entry must include bibliography, even if it is unpublished</sch:assert>-->
            <sch:assert test="t:bibl/*[1]">Every entry must include bibliography; use "unpub" for unpublished inscriptions</sch:assert> 
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern>
        <sch:rule context="t:bibl[ancestor::t:sourceDesc]">
            <sch:assert test="t:ref | t:ptr">Every <name/> should have either a ref or a ptr.</sch:assert>
        </sch:rule>
    </sch:pattern>
   
    <!-- Test for change log attribution -->
    <sch:pattern>
        <sch:rule context="//t:revisionDesc">
            <sch:report test="t:change[@who='xx']">Input your name in the change log and give a short description of what you did.</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Image name test -->
    <sch:pattern>
        <sch:rule context="//t:facsimile//t:graphic[not(starts-with(@url, 'http'))]">
            <sch:assert test="starts-with(@url, //t:publicationStmt/t:idno/@xml:id)">Image names should match the USEP ID (unless the image is a detail or alternate view, or the image is external)</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- Test for image formatting -->
    <sch:pattern>
        <sch:rule context="//t:facsimile">
            <sch:report test="//t:surface/t:graphic[2]">Each image must have its own surface element; do not put multiple graphic elements in the same surface element</sch:report>            
        </sch:rule>
    </sch:pattern>
    
    <!-- Test gap attributes -->
    <sch:pattern>
        <sch:rule context="//t:gap">
            <sch:report test="(@extent and @quantity)">Conflict: @quantity and @extent both present on <name/></sch:report>
            <sch:report test="(@reason='lost' or @reason='omitted') and not(@extent or @quantity or (@atLeast and @atMost))"><name/> needs one of @extent, @quantity or both @atLeast and @atMost</sch:report>
            <sch:report test="(@reason='lost' or @reason='omitted') and not(@unit)"><name/> lost or omitted needs @unit</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Test space attributes -->
    <sch:pattern>
        <sch:rule context="//t:space">
            <sch:report test="(@extent and @quantity)">conflict: @quantity and @extent both present on <name/></sch:report>
            <sch:report test="(@reason='lost' or @reason='omitted') and not(@extent or @quantity or (@atleast and @atMost))"><name/> needs one of @extent, @quantity or both @atLeast and @atMost</sch:report>
            <sch:report test="(@reason='lost' or @reason='omitted') and not(@unit)"><name/> lost or omitted needs @unit</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Check for gaps in supplied -->
    <sch:pattern>
        <sch:rule context="//t:div[@type='edition']//t:gap[not(@reason='ellipsis')]">
            <sch:report test="ancestor::t:supplied[not(@reason='undefined')]">Supplied may not contain <name/></sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Checking for Leiden sigla -->
    <sch:pattern>
        <!-- the regexes below will only work if you have Schematron set to XPATH version 2.0 in your local environment -->
        <!-- in Oxygen: Options > Preferences > XML > XML Parser > Schematron -->
        <sch:rule context="//t:div[@type='edition']">
            <sch:report test="descendant::text()[not(ancestor::t:desc or ancestor::t:note)][matches(.,'[\[\]\(\)]')]">Brackets and parentheses in epigraphic text</sch:report>
            <sch:report test="descendant::text()[not(ancestor::t:desc or ancestor::t:note)][matches(.,'&#x0323;|&#xE1C0;')]">Underdots in epigraphic text</sch:report>
            <sch:report test="descendant::text()[not(ancestor::t:desc or ancestor::t:note)][matches(.,'&lt;|&gt;')]">Angle brackets in epigraphic text</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- Check for untagged words -->
    <!--<sch:pattern>
        <sch:rule context="//t:div[@type='edition']">
            <sch:report test="descendant::text()[not(ancestor::t:w or ancestor::t:name or ancestor::t:placeName or ancestor::t:geogName or ancestor::t:num or ancestor::t:surplus
                or ancestor::t:orig or ancestor::t:desc or ancestor::t:note or ancestor::t:head or ancestor::t:g or ancestor::t:abbr[not(ancestor::t:expan)])][not(translate(normalize-space(translate(.,',.;··:','')),' ','')='')]">
                Character content needs to be tagged as word or name or number or undefined etc.
            </sch:report>
        </sch:rule>
    </sch:pattern>-->
    
    <!-- Check for problems with names and persnames -->
    <sch:pattern>
        <sch:rule context="//t:div[@type='edition']//t:name">
            <sch:report test="not(ancestor::t:persName or ancestor::t:placeName)"><name/> needs to be inside persName or placeName</sch:report>
        </sch:rule>
       <!-- <sch:rule context="//t:div[@type='edition']//t:persName">
            <sch:report test="not(@type=('divine','emperor','ruler','consul','attested','other'))"><name/> @type needs to be one of 'divine','emperor','ruler',consul','attested','other'</sch:report>
        </sch:rule>-->
    </sch:pattern>
    
    <!-- Problems with abbreviations/expansions -->
    <sch:pattern>
        <sch:rule context="//t:ex">
            <sch:report test="not(ancestor::t:expan)"><name/> should only appear inside expan</sch:report>
            <sch:report test="parent::t:abbr"><name/> should not be a child of abbr</sch:report>
        </sch:rule>
        <sch:rule context="//t:expan">
            <!--<report test="not(descendant::t:ex)"><name/> should contain ex</report><-->
            <sch:report test="descendant::text()[not(translate(normalize-space(.),' ','')='')][not(ancestor::t:ex or ancestor::t:abbr)]">all text in expan should be in abbr or ex</sch:report>
        </sch:rule>        
    </sch:pattern>

    <sch:diagnostics>
        <sch:diagnostic id="USEPID-start">
            - <sch:value-of select="$xmlid"/> - and
           - <sch:value-of select="concat($region, '.', $settlement, '.', $institution)"/> -
        </sch:diagnostic>
        <sch:diagnostic id="USEPID-accession">
            <sch:value-of select="substring-after($xmlid, 'L.')"/>
        </sch:diagnostic>
        <sch:diagnostic id="docTest">
            <sch:value-of select="substring-before(document-uri(/), '.xml')"/>
        </sch:diagnostic>
    </sch:diagnostics>
</sch:schema>