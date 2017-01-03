<% if $Items.count %>
    <ul>
        <% loop $Items %>
            <li>
                <% if $Link %>
                    <a href="$Link"><span data-filter="Requires">$Name</span></a>:
                    <% if $Description %>
                        $Description
                    <% else %>
                        <% if $Name = 'silverstripe/framework' || $Name = 'silverstripe/cms' %>
                        <span data-filter="Core-Requirement">$Constraint</span>
                        <% else %>
                            $Constraint
                        <% end_if %>
                    <% end_if %>
                <% else %>
                    <span data-filter="Requires">$Name</span>: <% if $Description %>$Description<% else %>$Constraint<% end_if %>
                <% end_if %>
            </li>
        <% end_loop %>
    </ul>
<% else %>
    <p class="muted">None</p>
<% end_if %>
