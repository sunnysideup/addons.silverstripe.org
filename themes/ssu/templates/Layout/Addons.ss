
<header>
    <h1>The World's Best Silverstripe Themes and Modules</h1>
    <p>
        Brought to you by <a href="http://www.sunnysideup.co.nz/">Sunny Side Up</a>.
        Please hire us for your next Silverstripe Project.
    </p>
 </header>
<% if $Addons %>
<div class="tableFilterSortHolder loading">
    <div class="tableFilterSortFilterFormHolder"
        data-title="Filter Modules and Themes"
        data-title-close-and-apply="Apply Filter"
    ></div>
    <p class="tableFilterSortMoreEntries paginationTop">
        <span class="line">
            <strong>Select Page: </strong><span class="pagination"></span>
        </span>
    </p>
    <p class="tableFilterSortMoreEntriesAlwaysShow">
        <span class="line">
            <strong>Filter:</strong>
            <span class="match-row-number">0</span> /
            <span class="total-row-number">0</span>
        </span>
    </p>

    <div class="tableFilterSortCommonContentHolder" data-title="Common Info"></div>

    <table class="tableFilterSortTable">
        <thead>
            <tr>
                <th scope="col">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Title"
                        data-sort-direction="asc"
                        data-sort-type="string"
                    >Title</a> +
                    <a href="#"
                        class="sortable"
                        data-sort-field="Team"
                        data-sort-direction="asc"
                        data-sort-type="string"
                    >Team</a>
                </th>
                <th scope="col">Description + Tags</th>
                <th scope="col" class="number">
                    <a href="#"
                        class="sortable"
                        data-sort-field="RD"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-default="true"
                        data-sort-only="true"
                    >Release Date</a>
                </th>
                <th scope="col" class="number">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Downloads"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-only="true"
                    >Downloads</a>
                </th>
                <th scope="col" class="number">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Versions"
                        data-sort-direction="desc"
                        data-sort-type="number"
                    >Versions</a> + Requirements
                </th>
            </tr>
        </thead>
        <tbody>
        <% loop $Addons %>
            <tr class="tfsRow">
                <th class="t-row" scope="row">
                    <span data-filter="Title" class="ignore more">$PackageName</span>
                    <div style="display: none;" class="hidden">
                        <ul>
                            <li>Type: <span data-filter="Type" class="dl">$Type</span>
                            <li>Team: <span data-filter="Team" class="dl">$Vendor.Name</span></li>
                        <% if Screenshots %>
                            <li class="placeholder img">
                                <% loop Screenshots %>
                                <% if First %>
                                <img src="$SetRatioSize(150,150).Link" />
                                <% end_if %>
                                <% end_loop %>
                            </li>
                        <% end_if %>
                        </ul>
                    </div>
                    <p>
                        <!-- <a href="$FavouriteLink" class="externalLink favourite" target="_blank" title="Add to Favourites">♥</a> -->
                        <a href="$Repository" class="externalLink github" target="_blank" title="View Repository">go to github</a>
                        <a href="$PackagistUrl" class="externalLink packagist" target="_blank" title="View on Packagist">go to packagist</a>
                    </p>
                </th>
                <td class="k-row">
                    $Description.LimitCharacters(450)
                    <% if $FilteredKeywords %>
                    <ul style="display: none;" class="hidden">
                    <% loop $FilteredKeywords %>
                        <li><span data-filter="Tag" class="dl">$Name</span></li>
                    <% end_loop %>
                    </ul>
                    <% end_if %>
                </td>
                <td class="rd-row">
                    $Released.Format(d M Y)
                    <span data-filter="RD" style="display: none">$Released.Format(U)</span>
                </td>
                <td class="dl-row">
                    <span data-filter="Downloads">$Downloads</span>
                </td>
                <td class="nv-row">
                    <span data-filter="Versions">$SortedVersions.Count</span>
                    <div style="display: none;" class="hidden">
                    <% loop $SortedVersions %>
                        <% if $First %>
                            <% include AddonVersionDetails %>
                            <p>Requirements based on <strong>$DisplayVersion</strong></p>
                        <% end_if %>
                    <% end_loop %>
                    </div>
                </td>
            </tr>
        <% end_loop %>
        </tbody>
    </table>
    <p class="tableFilterSortMoreEntries">
        <span class="line">
            <strong>Filtered:</strong>
            <span class="match-row-number">0</span> /
            <span class="total-row-number">0</span>
        </span>
        <span class="line">
            <strong>Currently Displaying:</strong>
            <span class="total-showing-row-number">0</span>
            (<span class="min-row-number">0</span>
            - <span class="max-row-number">0</span>)
        </span>
        <span class="line">
            <strong>Select Page:</strong> <span class="pagination"></span>
        </span>
    </p>


</div>
<% else %>
    <p>There are no add-ons to display.</p>
<% end_if %>
