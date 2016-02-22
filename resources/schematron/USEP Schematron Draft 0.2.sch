<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2" xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    <ns uri="http://www.tei-c-org/ns/1.0" prefix="t"/>
    
    <!--*******
    This provides validation for encoders while working on their transcriptions. The transcription-oriented are drawn from the sample schematron provided on the EpiDoc sourceforge,
    with several customizations for the US Epigraphy Project added, especially with respect to bibliography and metadata.
    **Change log:
    2015-11-02 SJD began; took transcription rules from sourceforge and adding rules for IDs and file names, image names, empty bibliography, image formatting
    2015-11-03 SJD added variable and put into schematron 1.7, working on simplifying the test for matching machine-readable id and itemized elements
    2015-11-04 SJD added rules for empty genre, support type, material, condition, handNote, location, date, and change log
    2016-02-22 SJD 
    -->
    
    <!-- Variable declaration -->
    <let name="region" value="/t:TEI/t:teiHeader/t:fileDesc/t:sourcDesc/t:msDesc/t:msIdentifier/t:region"/>
    <let name="settlement" value="/t:TEI/t:teiHeader/t:fileDesc/t:sourcDesc/t:msDesc/t:msIdentifier/t:settlement"/>
    <let name="institution" value="/t:TEI/t:teiHeader/t:fileDesc/t:sourcDesc/t:msDesc/t:msIdentifier/t:institution"/>
    <let name="repository" value="/t:TEI/t:teiHeader/t:fileDesc/t:sourcDesc/t:msDesc/t:msIdentifier/t:repository"/>
    <let name="xmlid" value="/t:TEI/t:teiHeader/t:fileDesc/t:publicationStmt/t:idno[@xml:id]"/>
    
    <!-- Test machine readable name -->
    <pattern>
        <rule context="//t:publicationStmt/t:idno">
            <assert test="//t:idno[@xml:id] != //t:idno">Machine- and Human-Readable IDs must match</assert>
        </rule>
    </pattern>
    
    <!-- Test machine readable id against broken out version -->
    <pattern>
        <rule context="//t:fileDesc">
            <assert test="starts-with($xmlid, concat($region, '.', $settlement, '.', $institution, '.', $repository)) or starts-with($xmlid, concat($region, '.', $settlement, '.', $institution))">USEP ID must match the individual elements listed in the itemized section</assert>
            <assert test="matches(substring-after($xmlid, '(L|G|GL|Etr|Raet)\.'), //t:msIdentifier/t:idno)">ID no. must match end of USEP ID</assert>
        </rule>        
    </pattern>
    
    <!-- Test for empty genre -->
    <pattern>
        <rule context="//t:msContents">
            <report test="//t:msItem[@class='#xx']">Every inscription must have a valid genre</report>
        </rule>
    </pattern>
    
    <!-- Test for empty support material -->
    <pattern>
        <rule context="//t:physDesc">
            <report test="//t:supportDesc[@ana='#xx']">Every inscription must have a valid material</report>
        </rule>
    </pattern>
    
    <!-- Test for empty condition --><pattern>
        <rule context="//t:physDesc/t:objectDesc/t:supportDesc/t:condition">
            <report test="//t:condition[@ana='#xx']"></report>
        </rule>
    </pattern>
    
    <!-- Test for multiple ps under supportDesc -->
    <pattern>
        <rule context="//t:physDesc">
            <report test="//t:supportDesc/t:support/t:p[2]">Cannot have two p-elements contained under support</report>
        </rule>
    </pattern>
    
    <!-- Test for empty objectDesc -->
    <pattern>
        <rule context="//t:physDesc">
            <report test="//t:objectDesc[@ana='#xx']">Every entry must contain a valid object type</report>
        </rule>
    </pattern>
    
    <!-- Test for empty handNote -->
    <pattern>
        <rule context="//t:physDesc/t:handDesc">
            <report test="//t:handNote[@ana='#xx']">Every entry must contain a valid writing description; if unknown, mark as such</report>
        </rule>
    </pattern>
    
    <!-- Test for empty date fields -->
    <pattern>
        <rule context="//t:history/t:origin">
            <report test="//t:date='Date to be displayed'">Enter a date for the inscription</report>
            <report test="(//t:date[@notBefore='0001'] and //t:date[@notAfter='0002'])">Enter a range of dates for the inscription</report>
        </rule>
    </pattern>
    
    <!-- Test for empty place names -->
    <pattern>
        <rule context="//t:history/t:origin">
            <report test="//t:placeName[@ref='xx']">Inscription must have a valid place ref (e.g. europe.italy.rome)</report>
            <report test="//t:placeName='Detailed place name'">Inscription must have a location; if it is unknown, mark as such</report>
        </rule>
    </pattern>
    
    <!-- Test for empty bibl -->
    <pattern>
        <rule context="//t:listBibl">
            <assert test="normalize-space(.)">Every entry must include bibliography, even if it is unpublished</assert>
            <report test="//t:bibl/t:ptr[@target='#xx']">Every entry must include bibliography; use "unpub" for unpublished inscriptions</report>           
        </rule>
    </pattern>
    
    <!-- Test for change log attribution -->
    <pattern>
        <rule context="//t:revisionDesc">
            <report test="//t:change[@who='xx']">Input your name in the change log</report>
        </rule>
    </pattern>
    
    <!-- Image name test -->
    <pattern>
        <rule context="//t:facsimile">
            <report test="starts-with(//t:graphic[@url], //t:publicationStmt/idno[@xml:id])">Image names should match the USEP ID (unless the image is a detail or alternate view, or the image is external)</report>
        </rule>
    </pattern>
    
    <!-- Test for image formatting -->
    <pattern>
        <rule context="//t:facsimile">
            <report test="//t:surface/t:graphic[2]">Each image must have its own surface element; do not put multiple graphic elements under the same surface</report>            
        </rule>
    </pattern>
    
    <!-- Test gap attributes -->
    <pattern>
        <rule context="//t:gap">
            <report test="(@extent and @quantity)">Conflict: @quantity and @extent both present on <name/></report>
            <report test="(@reason='lost' or @reason='omitted') and not(@extent or @quantity or (@atLeast and @atMost))"><name/> needs one of @extent, @quantity or both @atLeast and @atMost</report>
            <report test="(@reason='lost' or @reason='omitted') and not(@unit)"><name/> lost or omitted needs @unit</report>
        </rule>
    </pattern>
    
    <!-- Test space attributes -->
    <pattern>
        <rule context="//t:space">
            <report test="(@extent and @quantity)">conflict: @quantity and @extent both present on <name/></report>
            <report test="(@reason='lost' or @reason='omitted') and not(@extent or @quantity or (@atleast and @atMost))"><name/> needs one of @extent, @quantity or both @atLeast and @atMost</report>
            <report test="(@reason='lost' or @reason='omitted') and not(@unit)"><name/> lost or omitted needs @unit</report>
        </rule>
    </pattern>
    
    <!-- Check for gaps in supplied -->
    <pattern>
        <rule context="//t:div[@type='edition']//t:gap[not(@reason='ellipsis')]">
            <report test="ancestor::t:supplied[not(@reason='undefined')]">Supplied may not contain <name/></report>
        </rule>
    </pattern>
    
    <!-- Checking for Leiden sigla -->
    <pattern>
        <!-- the regexes below will only work if you have Schematron set to XPATH version 2.0 in your local environment -->
        <!-- in Oxygen: Options > Preferences > XML > XML Parser > Schematron -->
        <rule context="//t:div[@type='edition']">
            <report test="descendant::text()[not(ancestor::t:desc or ancestor::t:note)][matches(.,'[\[\]\(\)]')]">Brackets and parentheses in epigraphic text</report>
            <report test="descendant::text()[not(ancestor::t:desc or ancestor::t:note)][matches(.,'&#x0323;|&#xE1C0;')]">Underdots in epigraphic text</report>
            <report test="descendant::text()[not(ancestor::t:desc or ancestor::t:note)][matches(.,'&lt;|&gt;')]">Angle brackets in epigraphic text</report>
        </rule>
    </pattern>
    
    <!-- Check for untagged words -->
    <pattern>
        <rule context="//t:div[@type='edition']">
            <report test="descendant::text()[not(ancestor::t:w or ancestor::t:name or ancestor::t:placeName or ancestor::t:geogName or ancestor::t:num or ancestor::t:surplus
                or ancestor::t:orig or ancestor::t:desc or ancestor::t:note or ancestor::t:head or ancestor::t:g or ancestor::t:abbr[not(ancestor::t:expan)])][not(translate(normalize-space(translate(.,',.;··:','')),' ','')='')]">
                Character content needs to be tagged as word or name or number or undefined etc.
            </report>
        </rule>
    </pattern>
    
    <!-- Check for problems with names and persnames -->
    <pattern>
        <rule context="//t:div[@type='edition']//t:name">
            <report test="not(ancestor::t:persName or ancestor::t:placeName)"><name/> needs to be inside persName or placeName</report>
        </rule>
        <rule context="//t:div[@type='edition']//t:persName">
            <report test="not(@type=('divine','emperor','ruler','consul','attested','other'))"><name/> @type needs to be one of 'divine','emperor','ruler',consul','attested','other'</report>
        </rule>
    </pattern>
    
    <!-- Problems with abbreviations/expansions -->
    <pattern>
        <rule context="//t:ex">
            <report test="not(ancestor::t:expan)"><name/> should only appear inside expan</report>
            <report test="parent::t:abbr"><name/> should not be a child of abbr</report>
        </rule>
        <rule context="//t:expan">
            <!--<report test="not(descendant::t:ex)"><name/> should contain ex</report><-->
            <report test="descendant::text()[not(translate(normalize-space(.),' ','')='')][not(ancestor::t:ex or ancestor::t:abbr)]">all text in expan should be in abbr or ex</report>
        </rule>        
    </pattern>  
</schema>