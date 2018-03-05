ID
PackageName
Type
Vendor__Name
AddonsAuthors__ss
Repository
Repository__URL
DocLink
Description__LimitCharacters__450
LastTaggedVersion__Released__Ago
Released__Format__U
LastTaggedVersion__Released__Format__U
DownloadsMonthly__Formatted
Downloads__Formatted

<tbody>
    <tr class="tfstr" id="tfsP{{ID}}">
        <th scope="row">
            <span data-filter="Title" class="more">{{PackageName}}</span>
            <div class="hidden">
                <ul>
                    <li>Type: <span data-filter="Type" class="dl">{{Type}}</span></li>
                    <li>
                        Team: <span data-filter="Team" class="dl">{{Vendor__Name}}</span>
                        {{AddonsAuthors__ss}}
                    </li>
                </ul>
            </div>
            <p>
                <a href="#" class="adf">♥</a>
                <a href="{{Repository__URL}}" class="ext git" target="_blank">repo</a>
                <a href="{{DocLink}}" class="ext doc">api</a><% end_if %>
            </p>
        </th>
        <td class="left">
            {{Description__LimitCharacters__450}}
            {{FilteredKeywords__ss}}
        </td>
        <td class="right">
            {{Released__Ago}} &gt; {{LastTaggedVersion__Released__Ago}}
            <span data-filter="RD" class="hide">{{Released__Format__U}}</span>
            <span data-filter="LU" class="hide">{{LastTaggedVersion__Released__Format__U}}</span>
        </td>
        <td class="right">
            <span data-filter="MD">{{DownloadsMonthly__Formatted}}</span> /
            <span data-filter="DL">{{Downloads__Formatted}}</span>
        </td>
        <td class="right">
            <% include AddonVersionDetails %>
        </td>
    </tr>
</tbody>
