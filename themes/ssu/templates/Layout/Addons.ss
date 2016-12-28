
<div class="tableFilterSortHolder">
<% if $Addons %>
    <table>
        <thead>
            <tr>
                <th scope="col">
                    <a href="#"
                        class="sortable"
                        data-filter="Title"
                        data-sort-direction="asc"
                        data-sort-type="text"
                    >Title</a>
                    and Author(s)</th>
                <th scope="col">Tags and Description</th>
                <th scope="col">Requirements</th>
                <th scope="col">
                    <a href="#"
                        class="sortable"
                        data-filter="Downloads"
                        data-sort-direction="asc"
                        data-sort-type="number"
                    >Size</a>
                </th>
                <th scope="col">
                    <a href="#"
                        class="sortable"
                        data-filter="Versions"
                        data-sort-direction="asc"
                        data-sort-type="number"
                    >Versions</a>
                </th>
            </tr>
        </thead>
        <tfoot></tfoot>
        <tbody>
        <% loop $Addons %>
            <tr class="tfsRow">
                <td class="t-row">
                    <% if $Type == "module" %>
                        <i class="icon-th-large"></i>
                    <% else_if $Type == "theme" %>
                        <i class="icon-picture"></i>
                    <% end_if %>
                    <a href="$Repository"><span data-filter="Title">$PackageName</span></a>
                    <a href="#" class="more" data-rel="tandd_$ID">+</a>
                    <div style="display: none;" id="tandd_$ID">
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
                </td>
                <td class="k-row">
                    <% loop $Keywords %>
                        <span data-filter="Tag">$Name</span><% if $Last %>.<% else %>,<% end_if %>
                    <% end_loop %>
                    $Description.LimitCharacters(255)
                </td>
                <td  class="r-row">
                    <% loop $SortedVersions %>
                        <% if $First %>
                            <% include AddonVersionDetails %>
                        <% end_if %>
                    <% end_loop %>
                </td>
                <td class="dl-row">
                    $Downloads
                </td>
                <td class="nv-row">
                    $SortedVersions.Count
                </td>

            </tr>
        <% end_loop %>
        </tbody>
    </table>
<% else %>
    <p>There are no add-ons to display.</p>
<% end_if %>
</div>
