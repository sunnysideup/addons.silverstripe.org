
<% if $Addons %>
<div class="tableFilterSortHolder">
    <div class="tableFilterSortFilterFormHolder"
        data-title="My Filter Title"
        data-title-close-and-apply="Apply"
    ></div>
    <p class="tableFilterSortMoreEntries">
        <span class="line">
            Filter:
            <strong class="match-row-number">0</strong> /
            <strong class="total-row-number">0</strong>.
        </span>
    </p>
    <p class="tableFilterSortMoreEntries">
        <span class="line">
            Select Page: <strong class="pagination"></strong>
        </span>
    </p>
    <div class="tableFilterSortCommonContentHolder" data-title="Common Info"></div>

    <table class="tableFilterSortTable">
        <thead>
            <tr>
                <th scope="col">&nbsp;</th>
                <th scope="col">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Title"
                        data-sort-direction="asc"
                        data-sort-type="string"
                    >Title</a>
                    and Author(s)
                </th>
                <th scope="col">Tags and Description</th>
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
                    >Versions</a>
                </th>
                <th scope="col">&nbsp;</th>
            </tr>
        </thead>
        <tbody>
        <% loop $Addons %>
            <tr class="tfsRow">
                <td>
                    ＋
                </td>
                <th class="t-row" scope="row">
                    <% if $Type == "module" %>
                        <i class="icon-th-large"></i>
                    <% else_if $Type == "theme" %>
                        <i class="icon-picture"></i>
                    <% end_if %>
                    <a href="$Repository"><span data-filter="Title">$PackageName</span></a>
                    <a href="#" class="more" data-rel="auth_$ID">+</a>
                    <div style="display: none;" id="auth_$ID">
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
                    <a href="#" class="more" data-rel="desc_$ID">+</a>
                    <div style="display: none;" id="desc_$ID">
                        $Description.LimitCharacters(255)
                    </div>
                </td>
                <td  class="r-row">
                    <% loop $SortedVersions %>
                        <% if $First %>
                            <a href="#" class="more" data-rel="req_$ID">$DisplayVersion</a>
                            <div style="display: none;" id="req_$ID">
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
                    <span data-filter="RD">$Released.Format(U)</span>
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
            Filter:
            <strong class="match-row-number">0</strong> /
            <strong class="total-row-number">0</strong>.
        </span>
        <span class="line">
            Display: <strong class="total-showing-row-number">0</strong>
            (<strong class="min-row-number">0</strong>
            - <strong class="max-row-number">0</strong>).
        </span>
        <span class="line">
            Select Page: <strong class="pagination"></strong>
        </span>
    </p>


</div>
<% else %>
    <p>There are no add-ons to display.</p>
<% end_if %>
