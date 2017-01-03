<% with $Addon %>
    <div class="page-header">
        <p>
            <a href="/add-ons" class="btn btn-plain"><i class="icon-arrow-left"></i> Back to add-ons</a>
        </p>

        <div class="rating pull-right">
            <% include ModuleRatingVisual %>
            <% if $AdjustedHelpfulRobotScore %>
            <p>$AdjustedHelpfulRobotScore<small>/100</small></p>
            <% else %>
            <p>N/A <small>&nbsp;</small></p>
            <% end_if %>
            <a href="#rating-breakdown" class="rating-question"><i class="icon-question-sign"></i></a>
        </div>

        <h1>
            <a href="$VendorLink">$VendorName</a> / $PackageName
        </h1>

        <p>$Description</p>
    </div>

    <% if not $LastBuilt %>
        <p class="alert">
            The detailed information for this add-on has not yet been built.
        </p>
    <% end_if %>

    <% if $Screenshots %>
        <ul class="screenshots inline">
            <% loop $Screenshots %>
                <li>
                    <a href="$URL" target="_blank">
                        <img src="$CroppedImage(160, 160).URL" alt="$Up.Name.ATT" class="img-polaroid">
                    </a>
                </li>
            <% end_loop %>
        </ul>
    <% end_if %>

    <dl id="metadata">
        <% with $MasterVersion %>
            <dt>Homepage:</dt>
            <dd>
                <% if $DisplayHomepage %>
                <a href="$DisplayHomepage" rel="nofollow">$DisplayHomepage</a>
                <% end_if %>
            </dd>

        <% end_with %>

        <dt>Packagist:</dt>
        <dd><a href="$PackagistUrl" rel="nofollow">$PackagistUrl</a></dd>

        <dt>Repository:</dt>
        <dd>
            <a href="$Repository">$Repository</a>
        </dd>

        <% if $Authors %>
            <dt>Authors:</dt>
            <dd>
                <ul id="authors">
                <% loop $Authors %>
                    <li>
                        <a href="$Link">
                            <img src="$GravatarUrl(32)" class="img-polaroid" alt="$Name.ATT">
                            $Name
                        </a>
                    </li>
                <% end_loop %>
                </ul>
            </dd>
        <% end_if %>
    </dl>

    <hr>

    <% if $Readme %>
        <h3>Readme</h3>

        <div id="readme" class="collapsed">
            <div id="readme-inner">
                $Readme
            </div>
            <a href="#" id="readme-toggle">
                <i class="icon-arrow-up"></i>
                <i class="icon-arrow-down"></i>
            </a>
        </div>

        <hr>
    <% end_if %>

    <h3 id="rating-breakdown">Module rating breakdown</h3>

    <div class="row">
        <div class="span5">
            <div class="rating rating-border">
                <% include ModuleRatingVisual %>
                <% if $AdjustedHelpfulRobotScore %>
                <p>$AdjustedHelpfulRobotScore<small>/100</small></p>
                <% else %>
                <p>N/A <small>No data avaliable</small></p>
                <% end_if %>
            </div>
            <p>Module rating system helping users find modules that are well supported. For more on how the rating system works visit <a href="http://www.silverstripe.org/software/addons/supported-modules-definition/">Module standards</a></p>
            <p><small>Score not correct? <a href="mailto:community@silverstripe.com">Let us know there is a problem</a></small></p>
        </div>

        <% if $HelpfulRobotData %>
        <div class="span3 offset1">
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_readme_file %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Readme</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_license_file %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>FOSS License</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_code_folder %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Structured correctly</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_contributing_file %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Contributing file</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_change_log_file %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Change log</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_git_attributes_file %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Git attributes file</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_editor_config_file %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Editor config file</p>
            </div>
        </div>
        <div class="span3">
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_tests_folder %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Tests</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_docs_folder %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Documentation</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_travis_file %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Travis file</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_travis_setup %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Travis set up</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_scrutinizer_file %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Scrutinizer file</p>
            </div>
            <div class="rating-item">
                <div class="circle circle-option-sml<% if $HelpfulRobotData.has_scrutinizer_setup %> green<% else %> grey<% end_if %>">
                    <i class="icon-ok"></i>
                </div>
                <p>Scrutinizer set up</p>
            </div>
        </div>
        <% end_if %>
    </div>

    <h3>Versions</h3>

    <div id="versions" class="accordion">
        <% loop $SortedVersions %>
            <div class="accordion-group">
                <div class="accordion-heading">
                    <a class="accordion-toggle" data-toggle="collapse" data-parent="#versions" href="#version-$ID">
                        $DisplayVersion
                    </a>
                </div>
                <div id="version-$ID" class="version accordion-body collapse<% if First %> in<% end_if %>">
                    <div class="accordion-inner">
                        <% include AddonVersionDetails %>
                    </div>
                </div>
            </div>
        <% end_loop %>
    </div>

<% end_with %>