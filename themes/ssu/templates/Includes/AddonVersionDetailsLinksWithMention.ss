{{? Items }}
    <ul>
        {{~ Items :Item }}
            <li>
                {{? Item.Link }}
                    <a href="{{= Item.Link}}"><span data-filter="Mentions">{{= Item.Name }}</span></a>:
                    {{? Item.Description }}
                        {{= Item.Description }}
                    {{??}}
                        {{= Item.Constraint }}
                    {{?}}
                {{??}}
                    <span data-filter="Mentions">{{= Item.Name }}</span>: {{? Item.Description }}{{=Item.Description }}{{??}}{{= Item.Constraint}}{{?}}
                {{?}}
            </li>
        {{~}}
    </ul>
{{?}}
