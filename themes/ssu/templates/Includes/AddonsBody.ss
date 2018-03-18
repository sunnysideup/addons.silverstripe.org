<tr class="tfstr" id="tfsP{{= it.ID }}">

    <th scope="row">
        <span data-filter="Title" class="more">{{= it.Name}}</span>
        <div class="hidden">
            <ul>
                <li>Type: <span data-filter="Type" class="dl">{{= it.Type}}</span></li>
                <li>
                    Team: <span data-filter="Team" class="dl">{{= it.Team}}</span>
                    {{? it.Authors }} -
                    <ul>
                        {{~ it.Authors :v }}
                        <li><span data-filter="Authors" class="dl">{{= v }}</span></li>
                        {{~}}
                    </ul>
                    {{?}}
                </li>
            </ul>
        </div>
    </th>

    <td><a href="#" class="adf">♥</a></td>
    <td>{{? it.URL }}<a href="{{= it.URL}}" class="ext git">github</a>{{?}}</td>
    <td>{{? it.API }}<a href="{{= it.API}}" class="ext doc">{}</a>{{?}}</td>


    <td class="left">
        {{= it.Notes}}
        {{? it.Tags }}
        <ul class="hidden">
        {{~ it.Tags :v }}
            <li><span data-filter="Tags" class="dl">{{= v }}</span></li>
        {{~}}
        </ul>
        {{?}}
    </td>


    <td class="right">
        {{= it.Created}} &gt; {{= it.LastEdited}}
        <span data-filter="RD" class="hide">{{= it.Created_U}}</span>
        <span data-filter="LU" class="hide">{{= it.LastEdited_U}}</span>
    </td>


    <td class="right">
        <span data-filter="MD">{{= it.MInstalls }}</span> /
        <span data-filter="DL">{{= it.Installs }}</span>
    </td>


    <td class="right">

        {{? it.Supports }}
        {{~ it.Supports :v }} <span data-filter="Supports" class="dl">{{= v }}.*</span>{{~}}
        {{??}}
        <span data-filter="Supports" class="dl tba">tba</span>
        {{?}}

        <div class="hidden">

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

            <h5># Tags:</h5>
            {{= it.TagCount}}
        </div>
    </td>
</tr>
