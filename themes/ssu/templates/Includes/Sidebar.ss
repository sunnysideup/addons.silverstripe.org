
<div class="sidebarBox" id="SidebarChildren">
<% if Siblings %>
	<h3>Sibling Pages</h3>
	<% if Parent %>
	<p class="parentPageInfo">Other pages in the <% with Parent %><a href="$Link">$Title</a><% end_with %> section.</p>
	<% end_if %>
	<ul>
		<% loop Siblings %><li class="$FirstLast $LinkingMode"><a href="$Link">$MenuTitle</a></li><% end_loop %>
	</ul>
<% end_if %>
<% if MenuChildren %>
	<h3>In the <i>$MenuTitle</i> section</h3>
	<ul>
		<% loop MenuChildren %><li class="$FirstLast $LinkingMode"><a href="$Link">$MenuTitle</a></li><% end_loop %>
	</ul>
<% end_if %>
</div>


<% if SearchForm %>
<div class="sidebarBox" id="SidebarSearch">
	<h3>Still looking?</h3>
	<div class="searchFormOuter">$SearchForm</div>
</div>
<% end_if %>


<div class="sidebarBox" id="RandomImage">
	<h3>About Sunny Side Up</h3>
	<p>
		Sunny Side Up is a Wellington, Aotearoa / New Zealand based web development company.
		Our web-sites include:
	</p>
	<ul>
		<li><a href="http://www.sunnysideup.co.nz/">www.sunnysideup.co.nz</a>: the starting point,</li>
		<li><a href="http://www.ssmods.com/">ssmods.com</a>: our web-development services, </li>
		<li><a href="http://www.silverstripe-ecommerce.com/">silverstripe-ecommerce.com</a>: silverstripe e-commerce demo, </li>
		<li><a href="http://www.upgradesilverstripe.com/">upgradesilverstripe.com</a>: helps you to upgrade your silverstripe sites, </li>
		<li><a href="http://www.silverstripe-webdevelopment.com/">silverstripe-webdevelopment.com</a>: some developer notes, and</li>
	</ul>
<% if RandomImage %>
	<p>
		Random surprise:
	</p>
	<div id="RandomVisualThought" style="background-image: url($RandomImage.URL); width: 200px; height: 200px;" rel="$RandomImage.URL"></div>
<% end_if %>
</div>

