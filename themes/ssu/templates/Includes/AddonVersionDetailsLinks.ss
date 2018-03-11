{{? Items }}
    <ul>
        {{~ Items :Item }}
            <li>
                {{? Item.Link }}
                    <a href="{{= Item.Link}}"><span data-filter="Requires">{{ Item.Name }}</span></a>:
                    {{? Item.Description }}
                        {{= Item.Description }}
                    {{??}}
                        {{= Item.Constraint }}
                    {{?}}
                {{??}}
                    <span data-filter="Requires">{{ Item.Name</span>: {{ if {{ Item.Description }}{{ Item.Description{{ else }}{{ Item.Constraint{{ end_if }}
                {{?}}
            </li>
        {{ end_loop }}
    </ul>
{{?}}
