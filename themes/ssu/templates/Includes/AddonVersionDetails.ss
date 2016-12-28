<div class="row-fluid">
    <div class="span4">
        <h5>Requires</h5>
        <% include AddonVersionDetailsLinks Items=$Requires %>
    </div>
    <% if Suggests %>
    <div class="span4">
        <h5>Suggests</h5>
        <% include AddonVersionDetailsLinks Items=$Suggests %>
    </div>
    <% end_if %>
</div>

<% if Provides || Conflicts || Replaces %>
    <div class="row-fluid">
        <% if Provides %>
        <div class="span4">
            <h5>Provides</h5>
            <% include AddonVersionDetailsLinks Items=$Provides %>
        </div>
        <% end_if %>
        <% if Conflicts %>
        <div class="span4">
            <h5>Conflicts</h5>
            <% include AddonVersionDetailsLinks Items=$Conflicts %>
        </div>
        <% end_if %>
        <% if Replaces %>
        <div class="span4">
            <h5>Replaces</h5>
            <% include AddonVersionDetailsLinks Items=$Replaces %>
        </div>
        <% end_if %>
    </div>
<% end_if %>
