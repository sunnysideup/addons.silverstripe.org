

<% if $Addons %>
    <table>
        <thead>
            <tr>
                <th>Title</th>
                <th>Tags</th>
                <th>Description</th>
                <th>Requirements</th>
                <th>Downloads</th>
                <th>Number of Versions</th>
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

                    <a href="$Repository">$PackageName</a>
                    <br />$Vendor.Name
                    <% if Screenshots %>
                    <div class="placeholder img">
                        <% loop Screenshots %>
                        <% if First %>
                        <img src="$SetRatioSize(150,150).Link" />
                        <% end_if %>
                        <% end_loop %>
                    </div>
                    <% end_if %>
                </td>
                <td class="k-row">
                    <% loop $Keywords %>
                        $Name<% if $Last %>.<% else %>,<% end_if %>
                    <% end_loop %>
                </td>
                <td class="d-row">
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
