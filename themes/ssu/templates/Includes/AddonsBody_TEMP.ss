{{~ Row : it}}
<tr class="tfstr" id="tfsP{{= it.ID }}">
    <th scope="row">
        <span data-filter="Title" class="more">{{= it.PackageName}}</span>
        <div class="hidden">
            <ul>
                <li>Type: <span data-filter="Type" class="dl">{{= it.Type}}</span></li>
                <li>
                    Team: <span data-filter="Team" class="dl">{{= it.Vendor__Name}}</span>
                    {{? it.Authors }} -
                        <ul>
                            {{~ it.Authors :Author }}
                                <li><span data-filter="Author" class="dl">{{=Author.Name}}</span></li>
                            {{~}}
                        </ul>
                    {{?}}
                </li>
            </ul>
        </div>
        <p>
            <a href="#" class="adf">♥</a>
            <a href="{{= it.Repository__URL}}" class="ext git" target="_blank">repo</a>
            <a href="{{= it.DocLink}}" class="ext doc">api</a><% end_if %>
        </p>
    </th>
    <td class="left">
        {{= it.Description__LimitCharacters__450}}
        {{= it.FilteredKeywords__ss}}
    </td>
    <td class="right">
        {{= it.Released__Ago}} &gt; {{= it.LastTaggedVersion__Released__Ago}}
        <span data-filter="RD" class="hide">{{= it.Released__Format__U}}</span>
        <span data-filter="LU" class="hide">{{= it.LastTaggedVersion__Released__Format__U}}</span>
    </td>
    <td class="right">
        <span data-filter="MD">{{= it.DownloadsMonthly__Formatted}}</span> /
        <span data-filter="DL">{{= it.ownloads__Formatted}}</span>
    </td>
    <td class="right">
        {{? it.FrameworkSupport }}
        {{~ it.FrameworkSupport :FrameworkSupport }} <span data-filter="Supports" class="dl">{{FrameworkSupport.Supports}}.*</span>{{~}}
        {{ else }}
        <span data-filter="Supports" class="dl tba">tba</span>
        {{?}}

        <div class="hidden">
        {{? it.LastTaggedVersion }}
        {{~ it.LastTaggedVersion :LastTaggedVersion }}

        {{? it.Requires }}
        <h5>Requires</h5>
        {{~ it.Requires :Items }}
        <% include AddonVersionDetailsLinks %>
        {{~}}
        {{?}}

        {{? it.Suggests }}
        <h5>Suggests</h5>
        {{~ it.Suggests :Items }}
        <% include AddonVersionDetailsLinks %>
        {{~}}
        {{?}}

        {{? it.RequiresDev }}
        <h5>Requires Dev</h5>
        {{~ it.Suggests :Items }}
        <% include AddonVersionDetailsLinks %>
        {{~}}
        {{?}}

        {{? it.Provides }}
        <h5>Provides</h5>
        {{~ it.Provides :Items }}
        <% include AddonVersionDetailsLinksWithMention %>
        {{~}}
        {{?}}

        {{? it.Conflicts }}
        <h5>Conflicts</h5>
        {{~ it.Conflicts :Items }}
        <% include AddonVersionDetailsLinksWithMention %>
        {{~}}
        {{?}}

        {{? it.Replaces }}
        <h5>Replaces</h5>
        {{~ it.Replaces :Items }}
        <% include AddonVersionDetailsLinksWithMention %>
        {{~}}
        {{?}}

        {{~}}
        {{?}}

        <h5># Tags:</h5>
        {{= Versions__Count}}
        </div>
    </td>
</tr>
{{~}}
