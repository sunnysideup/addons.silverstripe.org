<footer id="footer">


    <h3>About ssmods.com</h3>
    <p>
        <a href="//ssmods.com/">ssmods.com</a> incorporates a number of sites.
        Together they make Silverstripe modules and themes easier to find.
        Sites currently available are:
    </p>

    <p>
        <strong><a href="//ssmods.com/">ssmods.com</a></strong>
        <br />
        Search a list of all Silverstripe Modules and Themes.
        The search options include filters by name, creator, Silverstripe version support, requirements, and others.
    </p>
    <p>
        <strong><a href="//topics.ssmods.com/">topics.ssmods.com</a></strong>
        <br />
        Silverstripe modules sorted into categories;
        showing Silverstripe modules by area of interest.
        This will help you, for example, to find all the dev-tool modules.
    </p>
    <p>
        <strong><a href="//docs.ssmods.com/">docs.ssmods.com</a></strong>
        <br />
        API documentation for all Silverstripe Modules.
        It is a great place to find code examples, specific methods and functionality within modules, and so on.
    </p>
    <p>
        The ssmods.com ecosystem is provided by <a href="//sunnysideup.co.nz/">Sunny Side Up</a>.
        It uses code from <a href="//addons.silverstripe.org/">the original Silverstripe addons site</a>.
        Of couse, we have built these sites using the <a href="//www.silverstripe.org/">Silverstripe CMS</a>.
        If you like to support our work then please hire us for your next Silverstripe project, provide feedback,
        or sponsor one of the sites.
    </p>

    <h3>Credits</h3>
    <p>
        A big thank you to Ralph, Florian, Ingrid and Aaron for their feedback.
    </p>

    <h3>Disclaimer</h3>
    <p>
        Do not rely on search results provided here.
        They can be misleading and out-of-date.
    </p>

    <h3>Feedback</h3>
    <p>
        We love your feedback.  <span class="email-us"></span>
    </p>

    <h3>Last Updated</h3>
    <p>$LocalNow</p>
    <p><a  class="int" href="#LayoutHolder">back to top</a></p>
</footer>
</div>
<script>

var coded = "AA3EWA@AKqqvAdWmK5.FE.qO";
var key = "y6Ms9uqhBOJXmGRZ2F10SgdPvIYAVKpa7LoN3rUT4ktlnjWzfbexHD5cC8EwiQ";
var shift = coded.length;
var link = "";
for (i = 0; i < coded.length; i++) {
    if (key.indexOf(coded.charAt(i))==-1) {
        ltr = coded.charAt(i);
        link += (ltr);
    } else {
        ltr = (key.indexOf(coded.charAt(i))-shift+key.length) % key.length;
        link += (key.charAt(ltr));
    }
}
jQuery('.email-us').html("<a href='mailto:"+link+"'>Please e-mail us.</a>");
</script>

</body>
</html>
