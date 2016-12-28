
<form id="home-search" action="/add-ons" method="get">
    <div class="addons-search-row">
        <label for="addons-search">Search for</label>
        <input id="addons-search" type="text" name="search" class="input-block-level">

        <button type="submit" class="btn">
            <i class="icon-search"></i> Search Add-ons
        </button>
    </div>
</form>

<hr>

<div class="row">
    <div class="addons-box span6">
        <h3><a href="/add-ons?sort=downloads">Popular Add-ons</a></h3>
        <ol>
            <% loop $PopularAddons(12) %>
                <li>
                    <a href="$Link">
                        <span class="name">$Name</span>
                        <span class="description">$Description</span>
                    </a>
                </li>
            <% end_loop %>
        </ol>
    </div>

    <div class="addons-box span6">
        <h3>
            <a href="/add-ons?sort=newest">Newest Add-ons</a>
            <a class="pull-right" href="/add-ons/rss"><img src="themes/addons/images/feed-icon-14x14.png" alt="RSS Feed" /></a>
        </h3>
        <ol>
            <% loop $NewestAddons(12) %>
                <li>
                    <a href="$Link">
                        <span class="name">$Name</span>
                        <span class="description">$Description</span>
                    </a>
                </li>
            <% end_loop %>
        </ol>
    </div>
</div>

<div class="row">
    <div class="addons-box span6">
        <h3>Newest Releases</h3>
        <ol>
            <% loop $NewestVersions(12) %>
                <li>
                    <a href="$Addon.Link">
                        <span class="name">$Name</span>
                        <span class="description">$Description</span>
                    </a>
                </li>
            <% end_loop %>
        </ol>
    </div>

    <div class="addons-box span6">
        <h3>Random Add-ons</h3>
        <ul>
            <% loop $RandomAddons(12) %>
                <li>
                    <a href="$Link">
                        <span class="name">$Name</span>
                        <% include ModuleRatingVisual SmallCircle=true %>
                        <span class="description">$Description</span>
                    </a>
                </li>
            <% end_loop %>
        </ul>
    </div>
</div>


<div class="row">
    <div class="addons-box span12">
        <h3>Statistics</h3>
        <ul>
            <li>Number of modules: $NumberOfModules</li>
            <li>Number of themes: $NumberOfThemes</li>
            <li>Number of 4.0 ready modules: $NumberOfModules(4)</li>
        </ul>
    </div>
</div>
