<tr class="tfstr" id="{{= it.ID }}">

    <td><a href="#" class="adf" title="add to recipe">♥</a></td>

    <td>{{? it.API }}<a href="{{= it.API}}" class="ext doc">API</a>{{?}}</td>

    <td>{{? it.URL }}<a href="{{= it.URL}}" class="ext git">github</a>{{?}}</td>

    <th scope="row">
        <span data-filter="Title" class="more">{{= it.Name}}</span>
        <div class="hidden">
            <span class="exact-name hide">{{= it.FullName}}</span>
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
        {{= it.Installs }}
        {{? it.Trending == 0 }}{{??}}<div class="trend-stars">{{= it.TrendingSimple }}</div>{{?}}
        <div class="hidden">
            <p>Installs per Month: <span data-filter="Trending">{{= it.AvgDownloads }}</span></p>
            <p>Installs in Last Month: {{= it.MInstalls }}</p>
            {{? it.Trending == 0 }}{{??}}<p>Trending Score: <span data-filter="Trending">{{= it.Trending }}</span>{{?}}
        </div>
    </td>


    <td class="right">

        {{? it.Supports }}
        {{~ it.Supports :v }} <span data-filter="Supports" class="dl">{{= v }}</span>{{~}}
        {{??}}
        <span data-filter="Supports" class="dl tba">tba</span>
        {{?}}

        <div class="hidden">

            {{? it.RequiresFull }}
            <h5>Requires</h5>
            {{~ it.RequiresFull :Item }}
            <% include AddonVersionDetailsLinks %>
            {{~}}
            {{?}}

            {{? it.SuggestsFull }}
            <h5>Suggests</h5>
            {{~ it.SuggestsFull :Item }}
            <% include AddonVersionDetailsLinks %>
            {{~}}
            {{?}}

            {{? it.RequiresDevFull }}
            <h5>Requires Dev</h5>
            {{~ it.SuggestsFull :Item }}
            <% include AddonVersionDetailsLinks %>
            {{~}}
            {{?}}

            {{? it.ProvidesFull }}
            <h5>Provides</h5>
            {{~ it.ProvidesFull :Item }}
            <% include AddonVersionDetailsLinksWithMention %>
            {{~}}
            {{?}}

            {{? it.ConflictsFull }}
            <h5>Conflicts</h5>
            {{~ it.ConflictsFull :Item }}
            <% include AddonVersionDetailsLinksWithMention %>
            {{~}}
            {{?}}

            {{? it.ReplacesFull }}
            <h5>Replaces</h5>
            {{~ it.ReplacesFull :Item }}
            <% include AddonVersionDetailsLinksWithMention %>
            {{~}}
            {{?}}

            <h5># Tags:</h5>
            {{= it.TagCount}}
        </div>
    </td>

</tr>
