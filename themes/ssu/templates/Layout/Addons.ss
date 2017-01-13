
<header>
    <h1 id="header">The World's Best Silverstripe Themes and Modules</h1>
    <p>
        Provided by <a href="http://www.sunnysideup.co.nz/">Sunny Side Up</a>.
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
                    >Created</a>
                </th>
                <th scope="col" class="number">
                    DL
                    <a href="#"
                        class="sortable"
                        data-sort-field="MD"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-default="true"
                        data-sort-only="true"
                    >last month</a> |
                    <a href="#"
                        class="sortable"
                        data-sort-field="DL"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-default="true"
                        data-sort-only="true"
                    >all time</a>
                </th>
                <th scope="col" class="number">
                    <a href="#"
                        class="sortable"
                        data-sort-field="LU"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-default="true"
                        data-sort-only="true"
                    >Last Change</a>
                </th>
                <th scope="col" class="number">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Framework Version"
                        data-sort-direction="desc"
                        data-sort-type="string"
                    >Up to SS</a>
                </th>
            </tr>
        </thead>
        <tbody>
        <% loop $Addons %>
            <tr class="tfsRow" id="tfs$ID">
                <th scope="row">
                    <span data-filter="Title" class="ignore more">$PackageName</span>
                    <div style="display: none;" class="hidden">
                        <ul>
                            <li>Type: <span data-filter="Type" class="dl">$Type</span>
                            <li>Team: <span data-filter="Team" class="dl">$Vendor.Name</span><% if $Authors %> -
                                <ul>
                                    <% loop $Authors %>
                                        <li><span data-filter="Author" class="dl">$Name</span><% if $Last %><% else %>,<% end_if %></li>
                                    <% end_loop %>
                                </ul>
                                <% end_if %>
                            </li>
                        </ul>
                    </div>
                    <p>
                        <a href="$FavouriteLink" class="externalLink addFav" target="_blank" title="Add to Favourites">♥</a>
                        <a href="$Repository" class="externalLink github" target="_blank">github</a>
                        <a href="$PackagistUrl" class="externalLink packagist" target="_blank">packagist</a>
                    </p>
                </th>
                <td>
                    $Description.LimitCharacters(450)
                    <% if $FilteredKeywords %>
                    <ul style="display: none;" class="hidden">
                    <% loop $FilteredKeywords %>
                        <li><span data-filter="Tag" class="dl">$Name</span></li>
                    <% end_loop %>
                    </ul>
                    <% end_if %>
                </td>
                <td class="right">
                    $Released.Ago<br />
                    <div style="display: none">
                        <span data-filter="RD">$Released.Format(U)</span>
                        <span data-filter="LU">$LastTaggedVersion.Released.Format(U)</span>
                    </div>
                </td>
                <td class="right">
                    <span data-filter="MD">$DownloadsMonthly.Formatted</span> |
                    <span data-filter="DL">$Downloads.Formatted</span>
                </td>
                <td class="right">
                    $LastTaggedVersion.Released.Ago
                </td>
                <td class="right">
                    <% loop $LastTaggedVersion %><% include AddonVersionDetails %><% end_loop %>
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
