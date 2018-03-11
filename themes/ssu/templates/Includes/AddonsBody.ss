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
            {{? it.Repository__URL }}<a href="{{= it.Repository__URL}}" class="ext git" target="_blank">repo</a>{{?}}
            {{? it.DocLink }}<a href="{{= it.DocLink}}" class="ext doc">api</a>{{?}}
        </p>
    </th>
</tr>
