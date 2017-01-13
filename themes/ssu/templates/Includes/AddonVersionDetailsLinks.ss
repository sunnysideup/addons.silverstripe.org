<% if $Items.count %>
    <ul>
        <% loop $Items %>
            <li>
                <% if $Link %>
                    <a href="$Link"><span data-filter="Requires">$Name</span></a>:
                    <% if $Description %>
                        $Description
                    <% else %>
                        $Constraint
                    <% end_if %>
                <% else %>
                    <span data-filter="Requires">$Name</span>: <% if $Description %>$Description<% else %>$Constraint<% end_if %>
                <% end_if %>
            </li>
        <% end_loop %>
    </ul>
<% end_if %>
