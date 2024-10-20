{{? Item }}
    <ul>
        <li>
            {{? Item.Link }}
                <a href="{{= Item.Link}}"><span data-filter="Requires">{{= Item.Name }}</span></a>:
                {{? Item.Description }}
                    {{= Item.Description }}
                {{??}}
                    {{= Item.Constraint }}
                {{?}}
            {{??}}
                <span data-filter="Requires">{{= Item.Name }}</span>: {{? Item.Description }}{{=Item.Description }}{{??}}{{= Item.Constraint}}{{?}}
            {{?}}
        </li>
    </ul>
{{?}}
