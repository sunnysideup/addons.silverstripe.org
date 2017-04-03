<footer>


    <h3>Also see ...</h3>
    <p>
        <strong><a href="//docs.ssmods.com/">Silverstripe module documentation / API</a></strong>: <br />
        Here you will find a myriad of code examples, API syntax, and additional documentation for all Silverstripe modules.
    </p>

    <p>
        <strong><a href="//topics.ssmods.com/">Silverstripe modules by area of interest</a></strong>: <br />
        We have gone through all the modules and sorted them into categories.
    </p>


    <h3>Credits</h3>
    <p>
        This site is provided by <a href="//sunnysideup.co.nz/">Sunny Side Up</a>.
        It use the basic code from <a href="//addons.silverstripe.org/">the original Silverstripe addons site</a>.
        It aims to provide an alternative way to find <a href="//www.silverstripe.org/">Silverstripe</a> Modules and Themes.
        A big thank you to Ralph, Florian, Ingrid and Aaron for their feedback.
    </p>

    <h3>Disclaimer</h3>
    <p>
        Do not rely on search results provided here.
        They can be misleading and out-of-date.
        Our aim is to make it easier to discover Silverstripe modules, not to provide advice or consultancy.
    </p>

    <h3>Feedback</h3>
    <p>
        We love your feedback.  <span class="email-us"></span>
    </p>

    <h3>Last Updated</h3>
    <p>$LocalNow</p>
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
