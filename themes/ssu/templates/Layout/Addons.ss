
<header>
    <h1 id="header">Find Silverstripe Themes and Modules <sup>BETA</sup></h1>
    <p>
        Provided by <a href="http://www.sunnysideup.co.nz/">Sunny Side Up</a>.
        Silverstripe specialists since 2007.
    </p>
 </header>
<% if $Addons %>
<main
    class="tfs-holder loading"
    data-filters-parent-page-id="Filter"
    data-favourites-parent-page-id="Favourites"
>

    <% include TableFilterSortHeader %>

    <table class="tfs-table">
        <thead>
            <tr>
                <th scope="col">
                    <a href="#"
                        class="sortable"
                        data-sort-field="Title"
                        data-sort-direction="asc"
                        data-sort-type="string"
                    >Title</a>
                </th>
                <th scope="col">Description + Tags</th>
                <th scope="col" class="number">
                    Edited:
                    <a href="#"
                        class="sortable"
                        data-sort-field="RD"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-default="true"
                        data-sort-only="true"
                    >first</a> &gt;
                    <a href="#"
                        class="sortable"
                        data-sort-field="LU"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-default="true"
                        data-sort-only="true"
                    >last</a>
                </th>
                <th scope="col" class="number">
                    Downloads:
                    <a href="#"
                        class="sortable"
                        data-sort-field="MD"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-default="true"
                        data-sort-only="true"
                    >30d</a> /
                    <a href="#"
                        class="sortable"
                        data-sort-field="DL"
                        data-sort-direction="desc"
                        data-sort-type="number"
                        data-sort-default="true"
                        data-sort-only="true"
                    >ever</a>
                </th>
                <th scope="col" class="works-with">
                    Works with
                </th>
            </tr>
        </thead>
        <tbody>
        <% loop $Addons %>
            <tr class="tfstr" id="tfs$ID">
                <th scope="row">
                    <span data-filter="Title" class="more">$PackageName</span>
                    <div class="hidden">
                        <ul>
                            <li>Type: <span data-filter="Type" class="dl">$Type</span></li>
                            <li>Team: <span data-filter="Team" class="dl">$Vendor.Name</span><% if $Authors %> -
                                <ul>
                                    <% loop $Authors %>
                                        <li><span data-filter="Author" class="dl">$Name</span><% if $Last %><% else %>,<% end_if %></li>
                                    <% end_loop %>
                                </ul>
                            <% end_if %></li>
                        </ul>
                    </div>
                    <p>
                        <a href="#" class="adf">♥</a>
                        <a href="$Repository" class="ext git" target="_blank">repo</a>
                        <% if $DocLink %><a href="$DocLink" class="ext doc">api</a><% end_if %>
                    </p>
                </th>
                <td class="left">
                    $Description.LimitCharacters(450)
                    <% if $FilteredKeywords %>
                    <ul class="hidden">
                    <% loop $FilteredKeywords %>
                        <li><span data-filter="Tag" class="dl">$Name</span></li>
                    <% end_loop %>
                    </ul>
                    <% end_if %>
                </td>
                <td class="right">
                    $Released.Ago &gt; $LastTaggedVersion.Released.Ago
                    <span data-filter="RD" class="hide">$Released.Format(U)</span>
                    <span data-filter="LU" class="hide">$LastTaggedVersion.Released.Format(U)</span>
                </td>
                <td class="right">
                    <span data-filter="MD">$DownloadsMonthly.Formatted</span> /
                    <span data-filter="DL">$Downloads.Formatted</span>
                </td>
                <td class="right">
                    <% include AddonVersionDetails %>
                </td>
            </tr>
        <% end_loop %>
        </tbody>
    </table>

    <% include TableFilterSortFooter %>


</main>
<% else %>
    <p>There are no add-ons to display.</p>
<% end_if %>
