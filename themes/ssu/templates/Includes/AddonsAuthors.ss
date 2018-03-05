<% if $Authors %> -
    <ul>
        <% loop $Authors %>
            <li><span data-filter="Author" class="dl">$Name</span><% if $Last %><% else %>,<% end_if %></li>
        <% end_loop %>
    </ul>
<% end_if %>
