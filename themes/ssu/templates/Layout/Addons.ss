
<% if $Addons %>
<div class="tableFilterSortHolder">
    <div class="tableFilterSortFilterFormHolder"
        data-title="My Filter Title"
        data-title-close-and-apply="Apply"
    ></div>
    <p class="tableFilterSortMoreEntries">
        <span class="line">
            <strong>Filter:</strong>
            <span class="match-row-number">0</span> /
            <span class="total-row-number">0</span>.
        </span>
    </p>
    <p class="tableFilterSortMoreEntries">
        <span class="line">
            <strong>Select Page: </strong><span class="pagination"></span>
        </span>
    </p>
    <div class="tableFilterSortCommonContentHolder" data-title="Common Info"></div>

    <table class="tableFilterSortTable">
        <thead>
            <tr>
                <th scope="col" class="action">&nbsp;</th>
                <th scope="col">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Title"
                        data-sort-direction="asc"
                        data-sort-type="string"
                    >Title</a>
                    &amp; Author(s)
                </th>
                <th scope="col">Tags &amp; Description</th>
                <th scope="col">Requirements</th>
                <th scope="col">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Downloads"
                        data-sort-direction="asc"
                        data-sort-type="string"
                    >Downloads</a>
                </th>
                <th scope="col">
                    <a href="#"
                        class="sortable"
                        data-sort-field="RD"
                        data-sort-direction="asc"
                        data-sort-type="number"
                    >Release Date</a>
                </th>
                <th scope="col">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Versions"
                        data-sort-direction="asc"
                        data-sort-type="number"
                    >Number of Versions</a>
                </th>
                <th scope="col" class="action">&nbsp;</th>
            </tr>
        </thead>
        <tbody>
        <% loop $Addons %>
            <tr class="tfsRow">
                <td class="action">
                    <a href="#" class="more">＋</a>
                </td>
                <th class="t-row" scope="row">
                    <% if $Type == "module" %>
                        <i class="icon-th-large"></i>
                    <% else_if $Type == "theme" %>
                        <i class="icon-picture"></i>
                    <% end_if %>
                    <a href="$Repository"><span data-filter="Title">$PackageName</span></a>
                    <div style="display: none;" class="hidden">
                        <br /><span data-filter="Vendor">$Vendor.Name</span>
                        <% if Screenshots %>
                        <div class="placeholder img">
                            <% loop Screenshots %>
                            <% if First %>
                            <img src="$SetRatioSize(150,150).Link" />
                            <% end_if %>
                            <% end_loop %>
                        </div>
                        <% end_if %>
                    </div>
                </th>
                <td class="k-row">
                    <% loop $Keywords %>
                        <span data-filter="Tag">$Name</span><% if $Last %>.<% else %>,<% end_if %>
                    <% end_loop %>
                    <div style="display: none;" class="hidden">
                        $Description.LimitCharacters(255)
                    </div>
                </td>
                <td  class="r-row">
                    <% loop $SortedVersions %>
                        <% if $First %>
                            $DisplayVersion
                            <div style="display: none;" class="hidden">
                            <% include AddonVersionDetails %>
                        </div>
                        <% end_if %>
                    <% end_loop %>
                </td>
                <td class="dl-row">
                    <span data-filter="Downloads">$Downloads</span>
                </td>
                <td class="rd-row">
                    $Released.Format(d M Y)
                    <span data-filter="RD" style="display: none">$Released.Format(U)</span>
                </td>
                <td class="nv-row">
                    <span data-filter="Versions">$SortedVersions.Count</span>
                </td>
                <td>
                    ♥
                </td>
            </tr>
        <% end_loop %>
        </tbody>
    </table>
    <p class="tableFilterSortMoreEntries">
        <span class="line">
            You have reached the limit of visble entries,
            there are more entries, but they can not be shown here as this will overload your browser.
        </span>
        <span class="line">
            <strong>Filtered:</strong>
            <span class="match-row-number">0</span> /
            <span class="total-row-number">0</span>.
        </span>
        <span class="line">
            <strong>Currently Displaying:</strong>
            <span class="total-showing-row-number">0</span>
            (<span class="min-row-number">0</span>
            - <span class="max-row-number">0</span>).
        </span>
        <span class="line">
            <strong>Select Page:</strong> <span class="pagination"></span>
        </span>
    </p>


</div>
<% else %>
    <p>There are no add-ons to display.</p>
<% end_if %>
