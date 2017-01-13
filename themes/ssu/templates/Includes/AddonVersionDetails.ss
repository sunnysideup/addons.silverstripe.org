<% if Requires %>
<% include AddonVersionDetailsLinks Items=$Requires %>
<% end_if %>

<div style="display: none;" class="hidden">
<% if Suggests %>
<h5>Suggests</h5>
<% include AddonVersionDetailsLinks Items=$Suggests %>
<% end_if %>
<% if Provides %>
<h5>Provides</h5>
<% include AddonVersionDetailsLinks Items=$Provides %>
<% end_if %>

<% if Conflicts %>
<h5>Conflicts</h5>
<% include AddonVersionDetailsLinks Items=$Conflicts %>
<% end_if %>

<% if Replaces %>
<h5>Replaces</h5>
<% include AddonVersionDetailsLinks Items=$Replaces %>
<% end_if %>
</div>
