<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"> 
<xsl:output method="html" indent="yes" version="4.0"/>


<xsl:template match="/">

<!-- SURVEY -->	
<xsl:for-each select="survey/question">
	<!-- START OF PAGE -->	
	<div id="pageN" data-role="page">
	  <xsl:attribute name="id">page<xsl:number count="question" level="any" />
	  </xsl:attribute>

		<!-- PAGE HEADER -->
		<div data-role="header" data-position="fixed" >
			<a href="#pageMyLocation" data-role="button" data-theme="a" data-icon="alert" data-iconpos="notext" data-rel="dialog" data-transition="fade" class="myLocationButton ui-btn-left ui-btn ui-btn-icon-notext ui-btn-corner-all ui-shadow ui-btn-up-a" title=""><span class="ui-btn-inner ui-btn-corner-all" aria-hidden="true"><span class="ui-btn-text"></span><span class="ui-icon ui-icon-alert ui-icon-shadow"></span></span></a>
			<h1>Question <xsl:number count="question" level="any" />/<xsl:value-of select="count(/survey/question)"/></h1>
			<a href="#pageSyncIndicatorHelp" class="transmitButton ui-btn-right ui-btn ui-btn-up-a ui-btn-icon-notext ui-btn-corner-all ui-shadow" data-rel="dialog" data-transition="fade" data-role="button" data-theme="a" data-icon="check" data-iconpos="notext" title=""><span class="ui-btn-inner ui-btn-corner-all" aria-hidden="true"><span class="ui-btn-text"></span><span class="ui-icon ui-icon-check ui-icon-shadow"></span></span></a>
    	</div>
		
		<!-- QUESTION/CONTENT -->
		<div data-role="content">
		  <fieldset data-role="controlgroup">
		  
			<!-- IF TEXTBOX -->
			<xsl:for-each select="text">
				<label for="textarea-a"><xsl:value-of select="../caption"/></label>
				<textarea 	name="textarea-{../caption}" 
							id="textarea-a" 
							caption="{../caption}"
							onchange="Home.handleFormChange(this);"><xsl:value-of select="default-text"/>
				</textarea>
				
			</xsl:for-each>
			
			<!-- IF RADIOBOX -->
			<xsl:for-each select="radio">			
				<legend><xsl:value-of select="../caption"/></legend>
				
				<xsl:for-each select="choice">
					<input type="radio" name="radio-choice-M" id="radio-choice-N" value="choice-N">			
						<xsl:attribute name="caption"><xsl:value-of select="../../caption"/>
						</xsl:attribute>
						<xsl:attribute name="choice"><xsl:value-of select="."/>
						</xsl:attribute>
						<xsl:attribute name="onclick">Home.handleFormChange(this);
						</xsl:attribute>
						<xsl:attribute name="name">radio-choice-<xsl:number count="radio" level="any" />
						</xsl:attribute>
						<xsl:attribute name="id">radio-choice-<xsl:number count="question" level="any" />-<xsl:value-of select="position()"/>
						</xsl:attribute>
						<xsl:attribute name="value">radio-choice-<xsl:value-of select="position()"/>
						</xsl:attribute>
					</input>
					
					<label for="radio-choice-N">
						<xsl:attribute name="for">radio-choice-<xsl:number count="question" level="any" />-<xsl:value-of select="position()"/>
						</xsl:attribute>
						<xsl:value-of select="current()"/>
					</label>
				</xsl:for-each>
			</xsl:for-each>
			
			<!-- IF CHECKBOX -->
			<xsl:for-each select="check">			
				<legend><xsl:value-of select="../caption"/></legend>
				<xsl:for-each select="choice">
					<input type="checkbox" name="check-choice-M" id="check-choice-N" class="custom">
						<xsl:attribute name="caption"><xsl:value-of select="../../caption"/>
						</xsl:attribute>
						<xsl:attribute name="choice"><xsl:value-of select="."/>
						</xsl:attribute>
						<xsl:attribute name="onclick">Home.handleFormChange(this);
						</xsl:attribute>
						<xsl:attribute name="name">check-choice-<xsl:number count="check" level="any" />
						</xsl:attribute>
						<xsl:attribute name="id">check-choice-<xsl:number count="question" level="any" />-<xsl:value-of select="position()"/>
						</xsl:attribute>
					</input>
					<label for="check-choice-N">
						<xsl:attribute name="for">check-choice-<xsl:number count="question" level="any" />-<xsl:value-of select="position()"/>
						</xsl:attribute>
						<xsl:value-of select="current()"/>
					</label>
				</xsl:for-each>
			</xsl:for-each>

		  </fieldset>		
		</div>
		
		
		<!-- FOOTER AND NAVBAR -->
		<div data-role="footer"  data-position="fixed" data-id="global-nav-bar">	
		
			<div class="navbarMenu">
				<div data-role="navbar" data-position="fixed">
					<ul>
					<li><a data-icon="back" onclick="hideMenu();"  href="#page1" data-role="button" data-transition="fade">Restart</a></li>
					<li><a data-icon="home" href="#home" data-role="button" data-transition="fade">Home</a></li>
					<li><a href="#infoPage" data-role="button" onclick="hideButtonDescriptions();" data-rel="dialog" data-transition="fade" data-icon="info">Help</a></li>
					</ul>
				</div><!-- /navbar -->				
			</div>		
		
			<div data-role="navbar" data-position="fixed">
				<ul>
					<!-- BACK BUTTON -->
					<li>
						<a href="#home" data-role="button" data-icon="arrow-l"  data-direction="reverse">
							<!-- If not on first page, back should go to previous page. -->
							<xsl:if test="position() &gt; 1">
								<xsl:attribute name="href">#page<xsl:value-of select="position()-1"/></xsl:attribute>
								<xsl:attribute name="data-transition">slide</xsl:attribute>
							</xsl:if>
							<!-- If on first page, back should go home. -->
							<xsl:if test="position() = 1">
								<xsl:attribute name="href">#home</xsl:attribute>
								<xsl:attribute name="data-transition">fade</xsl:attribute>
							</xsl:if>
						</a>
					</li>
					
					<!-- MENU BUTTON -->
					<li><a href="Javascript:toggleMenu()" data-role="button" data-icon="grid"></a></li>					
					
					<!-- NEXT BUTTON -->
					<li>
						<a href="#page2" data-role="button" data-icon="arrow-r"  data-transition="slide" data-direction="forward">
							<xsl:if test="position() &lt; count(/survey/question)">
								<!-- If not on last page, next should go to previous page. -->
								<xsl:attribute name="href">#page<xsl:value-of select="position()+1"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:if test="position() = count(/survey/question)">
								<!-- If on last page, next should go home. -->
								<xsl:attribute name="href">#verificationPage</xsl:attribute>
								<xsl:attribute name="data-rel">dialog</xsl:attribute>
							</xsl:if>
						</a>
					</li>
				</ul>
			</div><!-- /navbar -->
		</div><!-- /footer -->	
	</div><!-- /page -->
</xsl:for-each><!-- for-each survey/question -->

</xsl:template>
</xsl:stylesheet>